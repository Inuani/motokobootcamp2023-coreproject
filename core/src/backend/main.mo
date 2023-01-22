import Types "types";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Array "mo:base/Array";

// how to do an update proof hashmap ?

actor Embryo_dao {

    // CRUD user

    var userBase = HashMap.HashMap<Principal, Types.User>(1, Principal.equal, Principal.hash);

    public shared ({ caller }) func createNewUser(user : Types.User) : async Text {
        switch (userBase.get(caller)) {
            case (null) {
                userBase.put(caller, user);
                return "You are now registered, congrats!";
            };
            case (_) {
                // _ means any case
                return "Error :you are already registered!";
            };
        };
    };

    public shared query ({ caller }) func getUser() : async Types.Result<Types.User, Text> {
        let user = userBase.get(caller);
        switch (user) {
            case (null) {
                return #err("User not found for principal : " #Principal.toText(caller));
            };
            case (?some) {
                return #ok(some);
            };
        };
    };

    public shared ({ caller }) func updateUser(updatedInfo : Types.User) : async Types.Result<Text, Text> {
        let updatedUser = userBase.replace(caller, updatedInfo);
        switch (updatedUser) {
            case (null) {
                return #err("User not found for principal : " #Principal.toText(caller));
            };
            case (_) {
                return #ok("Your profile was successfully updated!");
            };
        };
    };

    public shared ({ caller }) func deleteUser() : async Types.Result<(), Text> {
        let userToBeDeleted = userBase.remove(caller);
        switch (userToBeDeleted) {
            case (null) {
                return #err("User not found for principal : " #Principal.toText(caller));
            };
            case (_) {
                return #ok();
            };
        };
    };

    // PROPOSAL

    var proposalBase = HashMap.HashMap<Nat, Types.Proposal>(1, Nat.equal, Hash.hash);
    stable var proposalIdCount : Nat = 0;

    public shared ({ caller }) func submitProposal(proposalSent : Text) : async {
        #Ok : Types.Proposal;
        #Err : Text;
    } {
        let user = userBase.get(caller);
        switch (user) {
            case (null) {
                return #Err("There is no registered user with principal :" #Principal.toText(caller));
            };
            case (_) {
                let newProposal : Types.Proposal = {
                    creator = caller;
                    description = proposalSent;
                    proposalId = proposalIdCount;
                    state = #open;
                    alreadyVoted = [];
                    yesVote = 0;
                    noVote = 0;
                };
                proposalBase.put(proposalIdCount, newProposal);
                proposalIdCount += 1;
                return #Ok(newProposal);
            };
        };
    };

    public shared ({ caller }) func vote(proposalId : Nat, yesOrNo : Bool) : async {
        #Ok : ();
        #Err : Text;
    } {
        let user = userBase.get(caller);
        switch (user) {
            case (null) {
                return #Err("There is no registered user with principal :" #Principal.toText(caller));
            };
            case (_) {
                switch (proposalBase.get(proposalId)) {
                    case (null) {
                        return #Err("The proposal id requested does not exist.");
                    };
                    case (?openProposal) {
                        for (principal in openProposal.alreadyVoted.vals()) {
                            if (principal == caller) {
                                return #Err("You already voted on this one dude!");
                            };
                        };
                        let alreadyVotedNew = Array.append<Principal>(openProposal.alreadyVoted, [caller]);
                        if (yesOrNo) {
                            let yesVoteNew = openProposal.yesVote + 1;
                            proposalBase.put(proposalId, {openProposal with alreadyVoted = alreadyVotedNew; yesVote = yesVoteNew});
                            return #Ok();
                        } else {
                            let noVoteNew = openProposal.noVote + 1;
                            proposalBase.put(proposalId, {openProposal with alreadyVoted = alreadyVotedNew; noVote = noVoteNew});
                            return #Ok();
                        };
                    };
                };
            };
        };
    };

    public query func getProposal(id : Nat) : async {
        #Ok : ?Types.Proposal;
        #Err : Text;
    } {
        let proposalRequested : ?Types.Proposal = proposalBase.get(id);
        switch (proposalRequested) {
            case (null) {
                return #Err("The proposal requested does not exist.");
            };
            case (_) {
                return #Ok(proposalRequested);
            };
        };
    };

    public query func getAllProposals() : async [(Nat, Types.Proposal)] {
        let allProposals = Iter.toArray(proposalBase.entries());
        return allProposals;
    };

};
