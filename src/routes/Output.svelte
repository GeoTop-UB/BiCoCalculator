<script lang="ts">
  import GridOutput from "./GridOutput.svelte";
  import Button from "$lib/components/Button.svelte";
  import Loader from "$lib/components/Loader.svelte";

  let { data, waiting, isMobile } = $props();

  interface Output {
    id: string;
    label: string;
    type: string;
  }
  interface ExtOutput extends Output {
    category: number;
    index: number;
  }
  interface Category {
    label: string;
    outputs: Output[];
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
  const listOutputs: ExtOutput[] = outputCategories
    .map((cat, idx) => {
      return cat.outputs.map((out) => {
        return {
          category: idx,
          ...out
        };
      });
    })
    .reduce((result, outsCat) => result.concat(outsCat), [])
    .map((out, idx) => {
      return {
        index: idx,
        ...out
      };
    });
  const outputsIndex = listOutputs.reduce((result: OutputsIndex, output: ExtOutput) => {
    result[output.id] = output;
    return result;
  }, {});
  const defaultOutput: string = outputCategories[0].outputs[0].id;

  let tab: string = $state(defaultOutput);
  let categorySelected: number = $state(0);
  let outputActive: boolean[] = $state([true, ...Array(listOutputs.length - 1).fill(false)]);

  let openMenuAttr = $derived({
    ...(!isMobile && { open: true })
  });
  let disabled = $derived(data === undefined);
  let n = $derived(data != undefined ? data.n : undefined);
  let datatab = $derived(data != undefined ? data[tab] : undefined);
  let type: string = $derived(outputsIndex[tab].type);

  async function onChangeTab() {
    const i = outputsIndex[tab].index;
    outputActive = [
      ...Array(i).fill(false),
      true,
      ...Array(listOutputs.length - i - 1).fill(false)
    ];
  }

  async function changeTab(id: string) {
    tab = id;
    categorySelected = outputsIndex[id].category;
    onChangeTab();
  }

  $effect(() => {
    if (data === undefined) {
      tab = defaultOutput;
      outputActive = [true, ...Array(listOutputs.length - 1).fill(false)];
    }
  });
</script>

<section class={data != undefined ? "loaded" : ""}>
  <div id="table-container-parent">
    <div id="table-container" class={type}>
      {#if datatab === undefined}
        {#if waiting}
          <Loader />
        {:else}
          <div>
            <p>
              Start by <strong>choosing a nilmanifold</strong> from the provided examples or entering
              your own by selection one of the options on the left.
            </p>
          </div>
        {/if}
      {:else}
        <GridOutput {datatab} {n} {type} />
      {/if}
    </div>
  </div>

  <nav>
    {#if isMobile}
      <select
        bind:value={categorySelected}
        onchange={() => changeTab(outputCategories[categorySelected].outputs[0].id)}
      >
        {#each outputCategories.entries() as [i, category]}
          <option value={i}>
            {category.label}
          </option>
        {/each}
      </select>
      <select bind:value={tab} onchange={onChangeTab}>
        {#each outputCategories[categorySelected].outputs as output}
          <option value={output.id}>
            {output.label}
          </option>
        {/each}
      </select>
    {:else}
      {#each outputCategories as category}
        <details {...openMenuAttr}>
          <summary>{category.label}</summary>

          <ul>
            {#each category.outputs as output}
              <Button
                label={output.label}
                onClick={() => changeTab(output.id)}
                bind:active={outputActive[outputsIndex[output.id].index]}
                {disabled}
              />
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
    /* width: 70%; */
    width: max-content;
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
    /* flex-grow: 1; */
    /* position: relative; */
    /* margin: 1rem; */
    height: 100%;
    overflow: auto;
    scrollbar-gutter: stable;
    /* align-content: center; */
    display: flex;
    flex-direction: row;
    /* justify-content: center; */
    align-items: center;
    max-width: calc(100vw - 24rem - 12rem - 4rem);
    width: calc(100vh - 5rem);
    min-width: 40rem;
  }

  #table-container {
    /* min-width: 100%; */
    /* height: 100%; */
    /* max-width: 72.59%; */
    display: flex;
    flex-direction: row;
    justify-content: center;
    /* overflow: auto;
    scrollbar-gutter: stable; */
    position: relative;
    overflow: hidden;
    min-width: min-content;
    max-width: 80%;
    margin: auto;
    padding: 0.8rem;
  }

  #table-container.zigzags {
    width: max-content;
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
      width: 12rem;
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
