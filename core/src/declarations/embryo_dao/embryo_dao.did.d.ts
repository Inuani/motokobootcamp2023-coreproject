import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Proposal {
  'creator' : Principal,
  'noVote' : bigint,
  'alreadyVoted' : Array<Principal>,
  'description' : string,
  'yesVote' : bigint,
  'state' : ProposalState,
  'proposalId' : bigint,
}
export type ProposalState = { 'open' : null } |
  { 'rejected' : null } |
  { 'accepted' : null };
export type Result = { 'ok' : string } |
  { 'err' : string };
export type Result_1 = { 'ok' : User } |
  { 'err' : string };
export type Result_2 = { 'ok' : null } |
  { 'err' : string };
export interface User { 'age' : bigint, 'name' : string }
export interface _SERVICE {
  'createNewUser' : ActorMethod<[User], string>,
  'deleteUser' : ActorMethod<[], Result_2>,
  'getAllProposals' : ActorMethod<[], Array<[bigint, Proposal]>>,
  'getProposal' : ActorMethod<
    [bigint],
    { 'Ok' : [] | [Proposal] } |
      { 'Err' : string }
  >,
  'getUser' : ActorMethod<[], Result_1>,
  'submitProposal' : ActorMethod<
    [string],
    { 'Ok' : Proposal } |
      { 'Err' : string }
  >,
  'updateUser' : ActorMethod<[User], Result>,
  'vote' : ActorMethod<[bigint, boolean], { 'Ok' : null } | { 'Err' : string }>,
}
