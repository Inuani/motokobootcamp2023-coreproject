export const idlFactory = ({ IDL }) => {
  const User = IDL.Record({ 'age' : IDL.Nat, 'name' : IDL.Text });
  const Result_2 = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const ProposalState = IDL.Variant({
    'open' : IDL.Null,
    'rejected' : IDL.Null,
    'accepted' : IDL.Null,
  });
  const Proposal = IDL.Record({
    'creator' : IDL.Principal,
    'noVote' : IDL.Nat,
    'alreadyVoted' : IDL.Vec(IDL.Principal),
    'description' : IDL.Text,
    'yesVote' : IDL.Nat,
    'state' : ProposalState,
    'proposalId' : IDL.Nat,
  });
  const Result_1 = IDL.Variant({ 'ok' : User, 'err' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  return IDL.Service({
    'createNewUser' : IDL.Func([User], [IDL.Text], []),
    'deleteUser' : IDL.Func([], [Result_2], []),
    'getAllProposals' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat, Proposal))],
        ['query'],
      ),
    'getProposal' : IDL.Func(
        [IDL.Nat],
        [IDL.Variant({ 'Ok' : IDL.Opt(Proposal), 'Err' : IDL.Text })],
        ['query'],
      ),
    'getUser' : IDL.Func([], [Result_1], ['query']),
    'submitProposal' : IDL.Func(
        [IDL.Text],
        [IDL.Variant({ 'Ok' : Proposal, 'Err' : IDL.Text })],
        [],
      ),
    'updateUser' : IDL.Func([User], [Result], []),
    'vote' : IDL.Func(
        [IDL.Nat, IDL.Bool],
        [IDL.Variant({ 'Ok' : IDL.Null, 'Err' : IDL.Text })],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
