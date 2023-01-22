import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Nat "mo:base/Nat";

module {

    public type User = {
        name : Text;
        age : Nat;
    };

    public type Proposal = {
        creator : Principal;
        description : Text;
        proposalId : Nat;
        state : ProposalState;
        alreadyVoted : [Principal];
        yesVote : Nat;
        noVote : Nat;
    };

    public type ProposalState = {
        #open;
        #accepted;
        #rejected;
    };

    public type Result<Ok,Err> = Result.Result<Ok,Err>;

};
