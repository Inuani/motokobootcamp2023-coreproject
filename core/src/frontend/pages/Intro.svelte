<script lang="ts">
  import { onMount } from "svelte";
  import { store } from "../store";
  import Login from "../components/Login.svelte";
  import Button from "../components/Button.svelte";
  import type { Proposal } from "src/declarations/embryo_dao/embryo_dao.did";
  // import logo from "../assets/skull_transparent_background.png";

  let proposals: [bigint, Proposal][] = [];

  async function getAllProposals() {
    let result = await $store.embryoDaoActor.getAllProposals();
    result.sort((a, b) => {
      return a[0] > b[0] ? 1 : -1;
    });
    return result;
  }

  onMount(async () => (proposals = await getAllProposals()));
</script>

{#if !$store.isAuthed}
  <Login />
{:else}
  <div>Principal: {$store.principal}</div>
  <div>AccountId: {$store.accountId}</div>
  <Button on:click={() => store.disconnect()}>disconnect</Button>
{/if}

<header class="App-header">
  <img src="../assets/skull_transparent_background.png" class="App-logo" alt="logo" />
  <p style="font-size: 2.5em; margin-bottom: 0.5em;">Lx 42 experimental Dao</p>
  <div
    style="display: flex; font-size: 1em; text-align: left; padding: 2em; border-radius: 30px; flex-direction: column; background: rgb(220 218 224 / 25%);"
  >
    <div style="text-align: center; font-size: 1.5em;">
      <code>Proposals :</code>
    </div>
    {#each proposals as proposal}
      <div>
        {proposal[0]} : {proposal[1].description}
      </div>
    {/each}
  </div>
</header>

<style global>
  body {
    background-color: #000000;
  }

  .App-logo {
    height: 15vmin;
    pointer-events: none;
    animation: pulse 3s infinite;
  }

  .App-header {
    margin-top: 150px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-size: calc(10px + 2vmin);
    color: #fff;
}


  .App-link {
    color: rgb(26, 117, 255);
  }

  .demo-button {
    background: #a02480;
    padding: 0 1.3em;
    margin-top: 1em;
    border-radius: 60px;
    font-size: 0.7em;
    height: 35px;
    outline: 0;
    border: 0;
    cursor: pointer;
    color: white;
  }

  .demo-button:active {
    color: white;
    background: #979799;
  }
</style>
