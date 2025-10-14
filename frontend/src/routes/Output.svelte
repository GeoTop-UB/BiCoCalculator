<script lang="ts">
  import GridOutput from "./GridOutput.svelte";
  import StickyButton from "$lib/components/StickyButton.svelte";
  import Loader from "$lib/components/Loader.svelte";

  let { data, waiting } = $props();

  interface Output {
    id: string
    label: string
    type: string
  }
  interface ExtOutput extends Output {
    category: number
  }
  interface Category {
    label: string
    outputs: Output[]
  }
  interface OutputsIndex {
    [id: string]: ExtOutput;
  }

  let outputCategories: Category[] = [
    {
      label: "Cohomologies",
      outputs: [
        {
          id: "cohomology_aeppli",
          label: "Aeppli",
          type: "cohomology"
        },
        {
          id: "cohomology_bottchern",
          label: "Bott-Chern",
          type: "cohomology"
        },
        {
          id: "cohomology_delbar",
          label: "Delbar",
          type: "cohomology"
        },
        {
          id: "cohomology_dell",
          label: "Del",
          type: "cohomology"
        },
        {
          id: "cohomology_reduced_aeppli",
          label: "Reduced Aeppli",
          type: "cohomology"
        },
        {
          id: "cohomology_reduced_bottchern",
          label: "Reduced Bott-Chern",
          type: "cohomology"
        }
      ]
    },
    {
      label: "Other invariants",
      outputs: [
        {
          id: "zigzags",
          label: "Zigzags",
          type: "zigzags"
        },
        {
          id: "squares",
          label: "Squares",
          type: "squares"
        }
      ]
    }
  ];
  function extendOutput(output: Output, categoryIdx: number): ExtOutput {
    return {
      category: categoryIdx,
      ...output
    };
  }
  const listOutputs = outputCategories[0].outputs.map(extendOutput, 0).concat(outputCategories[1].outputs.map(extendOutput, 1));
  const outputsIndex = listOutputs.reduce(function(result: OutputsIndex, output: ExtOutput) {
    result[output.id] = output;
    return result;
  }, {});
  const defaultOutput: Output = outputCategories[0].outputs[0];

  let tab: string = $state(defaultOutput.id);
  // let type: string = $state(defaultOutput.type);
  let categorySelected: number = $state(0);
  let firstActive = $state(false);
  let active = $state(false);
	let innerWidth = $state(0);

  let isMobile = $derived(innerWidth < 768);
	let openMenuAttr = $derived({
    ...(!isMobile && { open: true })
  });
  let disabled = $derived(data === undefined);
  let n = $derived(data != undefined ? data.n : undefined);
  let datatab = $derived(data != undefined ? data[tab] : undefined);
  let type: string = $derived(outputsIndex[tab].type)

  async function onChangeTab() {
    active = true;
    firstActive = true;
    active = false;
    firstActive = false;
  }

  async function changeTabSelect() {
    console.log("tab selected")
    // type = outputSelected.type;
    onChangeTab();
  }

  async function changeTab(id: string, newtype: string) {
    tab = id;
    // categorySelected = outputsIndex[id].category;
    // if (outputsIndex[id].category != categorySelected) {
    //   categorySelected = outputsIndex[id].category;
    // }
    // type = newtype;
    onChangeTab();
  }

  $effect(() => {
    tab = defaultOutput.id;
    // type = defaultOutput.type;
    active = true;
    active = false;
    if (data === undefined) {
      firstActive = true;
      firstActive = false;
    } else {
      firstActive = true;
    }
  });
</script>

<svelte:window bind:innerWidth={innerWidth} />

<section class="{data != undefined ? 'loaded' : ''}">
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
     {#if isMobile }
      <select
        bind:value={categorySelected}
        onchange={() => (tab = outputCategories[categorySelected].outputs[0].id)}
      >
        {#each outputCategories.entries() as [i, category]}
          <option value={i}>
            {category.label}
          </option>
        {/each}
      </select>
      <select
        bind:value={tab}
        onchange={changeTabSelect}
      >
        {#each outputCategories[categorySelected].outputs as output}
          <option value={output.id}>
            {output.label}
          </option>
        {/each}
      </select>
    {:else}
      {#each outputCategories.entries() as [i, category]}
        <details {...openMenuAttr}>
          <summary>{category.label}</summary>

          <ul>
            {#each category.outputs.entries() as [j, output]}
              {#if i === 0 && j === 0 }
                <StickyButton
                  label={output.label}
                  onClick={() => changeTab(output.id, output.type)}
                  active={firstActive}
                  {disabled}
                />
              {:else}
                <StickyButton
                  label={output.label}
                  onClick={() => changeTab(output.id, output.type)}
                  {active}
                  {disabled}
                />
              {/if}
            {/each}
          </ul>
        </details>
      {/each}
    {/if}
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

  @media screen and (max-width: 768px) {
    section {
      width: 100%;
      z-index: 1;
      /* position: absolute;
      top: 0;
      bottom: 40%; */
      flex-grow: 0;
      max-height: 0;
    }

    section.loaded {
      flex-direction: column-reverse;
      height: initial;
      flex-grow: 1;
      max-height: initial;
    }

    section.loaded #table-container-parent {
      flex-grow: initial;
      height: initial;
      width: 100%;
    }

    section.loaded #table-container {
      width: fit-content;
    }
    
    /* section.loaded nav {
      display: none;
    } */
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

  @media screen and (min-width: 768px) {
    nav > :last-child {
      margin-top: 2rem;
    }
    
    nav > details {
      display: flex;
      flex-direction: column;
      box-shadow:
        0 0 4px 0 rgba(0, 0, 0, 0.14),
        0 0 8px 0 rgba(0, 0, 0, 0.12),
        0 0 3px -2px rgba(0, 0, 0, 0.2);
    }

    summary::marker {
      content: "";
    }

    nav summary {
      font-size: medium;
      font-weight: bold;
      text-align: center;
      pointer-events: none; /* prevents click events */
      user-select: none; /* prevents text selection */
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

    nav > :last-child > ul {
      width: auto;
    }

    ul > :global(*) {
      width: 100%;
    }

    ul > :global(*):not(:last-child) {
      margin-bottom: 3px;
    }
  }

  @media screen and (max-width: 768px) {
    nav > :last-child {
      margin-left: 2rem;
    }

    nav {
      display: flex;
      justify-content: space-around;
      width: 100%;
      padding: 0.5rem 1rem;
    }
    
    section nav {
      display: none;
    }
    
    section.loaded nav {
      display: flex;
    }

    nav select {
      width: 10rem;
    }
  }
</style>
