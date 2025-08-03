<script>
  import TableOutput from './TableOutput.svelte'
  
  const tabs = [
    {
      "id": "cohomology_aeppli",
      "name": "Aeppli Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_bottchern",
      "name": "Bottchern Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_delbar",
      "name": "Delbar Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_dell",
      "name": "Dell Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_reduced_aeppli",
      "name": "Reduced Aeppli Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_reduced_bottchern",
      "name": "Reduced Bottchern Cohomology",
      "type": "cohomology",
    },
    {
      "id": "zigzags",
      "name": "Zigzags",
      "type": "zigzags",
    },
    {// TODO
      "id": "squares",
      "name": "Squares",
      "type": "cohomology",
    }
  ];

  let { data, n } = $props();
  
  let tab = $state(tabs[0]["id"])
  let type = $state(tabs[0]["type"])

	async function changeTab(t) {
    tab = t.id;
    type = t.type;
	}
</script>

<div id="output">
  <div class="tab">
  {#each tabs as t}
    <button class="tablinks" onclick={() => changeTab(t)}>{t.name}</button>
  {/each}
  </div>

  <TableOutput {data} {n} {type} {tab} />
</div>

<style>
  #output {
    width: 60%;
    margin: 1rem;
  }

  .tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
  }

  /* Style the buttons that are used to open the tab content */
  .tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
  }

  /* Change background color of buttons on hover */
  .tab button:hover {
    background-color: #ddd;
  }

  /* Create an active/current tablink class */
  .tab button.active {
    background-color: #ccc;
  }
</style>