<script lang="ts">
  import GridOutput from "./GridOutput.svelte";
  import StickyButton from "$lib/components/StickyButton.svelte";
  import Loader from "$lib/components/Loader.svelte";

  let { data, waiting } = $props();

  let tab = $state();
  let type = $state();
  let firstActive = $state(false);
  let active = $state(false);

  let disabled = $derived(data === undefined);
  let n = $derived(data != undefined ? data.n : undefined);
  let datatab = $derived(data != undefined ? data[tab] : undefined);

  async function changeTab() {
    active = true;
    firstActive = true;
    active = false;
    firstActive = false;
  }

  async function changeTabCohomology(id) {
    tab = id;
    type = "cohomology";
    changeTab();
  }

  async function changeTabOthers(id) {
    tab = id;
    type = id;
    changeTab();
  }

  $effect(() => {
    if (data === undefined) {
      tab = undefined;
      type = undefined;
      active = true;
      active = false;
      firstActive = true;
      firstActive = false;
    } else {
      tab = "cohomology_aeppli";
      type = "cohomology";
      active = true;
      active = false;
      firstActive = true;
    }
  });
</script>

<section>
  <div id="table-container-parent">
    <div id="table-container">
      {#if datatab === undefined}
        {#if waiting}
          <Loader />
        {:else}
          <div>
            <p>Click compute to see the invariants of the selected nilmanifold</p>
          </div>
        {/if}
      {:else}
        <GridOutput {datatab} {n} {type} />
      {/if}
    </div>
  </div>

  <nav>
    <div>
      <h2>Cohomologies</h2>

      <ul>
        <StickyButton
          label="Aeppli"
          onClick={() => changeTabCohomology("cohomology_aeppli")}
          active={firstActive}
          {disabled}
        />
        <StickyButton
          label="Bott-Chern"
          onClick={() => changeTabCohomology("cohomology_bottchern")}
          {active}
          {disabled}
        />
        <StickyButton
          label="Delbar"
          onClick={() => changeTabCohomology("cohomology_delbar")}
          {active}
          {disabled}
        />
        <StickyButton
          label="Del"
          onClick={() => changeTabCohomology("cohomology_dell")}
          {active}
          {disabled}
        />
        <StickyButton
          label="Reduced Aeppli"
          onClick={() => changeTabCohomology("cohomology_reduced_aeppli")}
          {active}
          {disabled}
        />
        <StickyButton
          label="Reduced Bott-Chern"
          onClick={() => changeTabCohomology("cohomology_reduced_bottchern")}
          {active}
          {disabled}
        />
      </ul>
    </div>

    <div id="decomposition">
      <h2>Other invariants</h2>

      <ul>
        <StickyButton
          label="Zigzags"
          onClick={() => changeTabOthers("zigzags")}
          {active}
          {disabled}
        />
        <StickyButton
          label="Squares"
          onClick={() => changeTabOthers("squares")}
          {active}
          {disabled}
        />
      </ul>
    </div>
  </nav>
</section>

<style>
  section {
    display: flex;
    flex-direction: row;
    align-items: center;
    width: 70%;
    /* margin: 1.8rem; */
    height: 100%;
  }

  #table-container-parent {
    flex-grow: 1;
    /* position: relative; */
    /* margin: 1rem; */
    height: 100%;
    overflow: auto;
    scrollbar-gutter: stable;
    align-content: center;
  }

  #table-container {
    width: 100%;
    /* height: 100%; */
    /* max-width: 72.59%; */
    display: flex;
    flex-direction: row;
    justify-content: center;
    /* overflow: auto;
    scrollbar-gutter: stable; */
    position: relative;
    overflow: hidden;
  }

  nav > div {
    display: flex;
    flex-direction: column;
    box-shadow:
      0 0 4px 0 rgba(0, 0, 0, 0.14),
      0 0 8px 0 rgba(0, 0, 0, 0.12),
      0 0 3px -2px rgba(0, 0, 0, 0.2);
  }

  nav h2 {
    font-size: medium;
    font-weight: bold;
    text-align: center;
  }

  nav ul {
    list-style: none;
    padding: 0;
    width: max-content;
    display: flex;
    flex-direction: column;
    margin: 8px;
    margin-top: 0;
  }

  #decomposition {
    margin-top: 2rem;
  }

  #decomposition ul {
    width: auto;
  }

  ul > :global(*) {
    width: 100%;
  }

  ul > :global(*):not(:last-child) {
    margin-bottom: 3px;
  }
</style>
