<script>
  import TableOutput from './TableOutput.svelte'
  import StickyButton from './StickyButton.svelte';

  let { data } = $props();

  let tab = $state("cohomology_aeppli");
  let type = $state("cohomology");
  let firstActive = $state(true);
  let active = $state(false);

  let n = $derived(data.n);
  let datatab = $derived(data[tab]);

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
    type = "zigzags";
    changeTab();
	}
</script>

<section>
  <div id="table-container">
    <TableOutput {datatab} {n} {type} />
  </div>

  <nav>
    <div>
      <h2>Cohomologies</h2>

      <ul>
        <StickyButton label="Aeppli" onClick={() => changeTabCohomology("cohomology_aeppli")} active={firstActive} />
        <StickyButton label="Bottchern" onClick={() => changeTabCohomology("cohomology_bottchern")} {active} />
        <StickyButton label="Delbar" onClick={() => changeTabCohomology("cohomology_delbar")} {active} />
        <StickyButton label="Dell" onClick={() => changeTabCohomology("cohomology_dell")} {active} />
        <StickyButton label="Reduced Aeppli" onClick={() => changeTabCohomology("cohomology_reduced_aeppli")} {active} />
        <StickyButton label="Reduced Bottchern" onClick={() => changeTabCohomology("cohomology_reduced_bottchern")} {active} />
      </ul>
    </div>

    <div id="decomposition">
      <h2>Decomposition</h2>
      
      <ul>
        <StickyButton label="Zigzags" onClick={() => changeTabOthers("zigzags")} {active} />
        <StickyButton label="Squares" onClick={() => changeTabOthers("squares")} {active} />
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
    margin: 1.8rem;
  }

  #table-container {
    flex-grow: 1;
    display: flex;
    flex-direction: row;
    justify-content: center;
  }

  nav > div {
    display: flex;
    flex-direction: column;
    box-shadow: 0 0 4px 0 rgba(0,0,0,.14),0 0 8px 0 rgba(0,0,0,.12),0 0 3px -2px rgba(0,0,0,.2);
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
    margin-top: 1rem;
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