<script lang="ts">
  import { math } from "mathlifier";
  import { untrack } from "svelte";

  import { compute, processResult, precomputedExamples, ExamplesID, hashInput } from "$lib/compute";
  import type { Data, Input, ComputationResult, ExamplesID as ExamplesIDT } from "$lib/compute";
  import Modal from "$lib/components/Modal.svelte";
  import Button from "$lib/components/Button.svelte";
  import ktInput from "$lib/precomputations/KT_Input.json";
  import iwInput from "$lib/precomputations/IW_Input.json";
  import jnInput from "$lib/precomputations/JN_Input.json";

  const MoreOptions = {
    CUSTOM: "CUSTOM"
  } as const;
  type MoreOptions = (typeof MoreOptions)[keyof typeof MoreOptions];
  const MoreMoreOptions = {
    DEFAULT: "",
    SELECTED_CUSTOM: "SELECTED_CUSTOM"
  } as const;
  type MoreMoreOptions = (typeof MoreMoreOptions)[keyof typeof MoreMoreOptions];
  const InputOptions = { ...ExamplesID, ...MoreOptions };
  type InputOptions = ExamplesIDT | MoreOptions;
  type MetadataInputOptions = {
    [e in InputOptions]: {
      label: string;
      callback: () => Promise<Input>;
    };
  };
  const inputOptions: MetadataInputOptions = {
    [InputOptions.KT]: {
      label: "Kodaira-Thurston",
      callback: () => {
        return Promise.resolve(ktInput);
      }
    },
    [InputOptions.IW]: {
      label: "Iwasawa",
      callback: () => {
        return Promise.resolve(iwInput);
      }
    },
    [InputOptions.JN]: {
      label: "Stelzig",
      callback: () => {
        return Promise.resolve(jnInput);
      }
    },
    [InputOptions.CUSTOM]: {
      label: "Enter nilmanifold...",
      callback: lieClick
    }
  };

  interface Props {
    input: Input | undefined;
    data: Data | undefined;
    waiting: boolean;
  }
  let { input = $bindable(), data = $bindable(), waiting = $bindable() }: Props = $props();

  let inputOption: InputOptions | MoreMoreOptions = $state(MoreMoreOptions.DEFAULT);
  let prevInputOption: InputOptions | MoreMoreOptions = $state(MoreMoreOptions.DEFAULT);
  let result: ComputationResult | undefined = $state.raw();
  let showModal = $state(false);
  let modalLie: string | undefined = $state();
  let modalSave = $state();
  let modalAbort = $state();

  let inputHash: string | undefined = $derived(input != undefined ? hashInput(input) : undefined);
  let saveDisabled = $derived.by(() => {
    if (modalLie != undefined) {
      try {
        let a = JSON.parse(modalLie);
        if (
          Object.hasOwn(a, "lie") &&
          Object.hasOwn(a.lie, "names") &&
          Object.hasOwn(a.lie, "bracket") &&
          Object.hasOwn(a, "acs") &&
          Object.hasOwn(a.acs, "names") &&
          Object.hasOwn(a.acs, "matrix") &&
          a.lie.names.length === a.acs.names.length &&
          a.lie.names.length === a.acs.matrix.length
          // TODO add more checks
          // && a.lie.names.length === a.acs.matrix[0].length
          // && a.lie.names.length === a.acs.norm.length
        ) {
          return false;
        }
      } catch (exceptionVar) {}
    }
    return true;
  });

  async function setInputOption() {
    if (inputOption != MoreMoreOptions.DEFAULT && inputOption != MoreMoreOptions.SELECTED_CUSTOM) {
      try {
        const i = await inputOptions[inputOption].callback();
        input = i;
        console.log("Input updated to:");
        console.log(untrack(() => $state.snapshot(input)));
        prevInputOption = inputOption;
      } catch (_) {
        console.log("Modal closed, reverting to previous option");
        inputOption = prevInputOption;
      }
    }
  }

  async function onEdit() {
    inputOption = InputOptions.CUSTOM;
    setInputOption();
  }

  async function computeResult(i: Input) {
    waiting = true;
    data = undefined;
    console.log("Data reset");
    result = await compute(i);
    console.log("Result updated to:");
    console.log(untrack(() => $state.snapshot(result)));
  }

  async function loadData(i: Input, r: ComputationResult) {
    waiting = true;
    data = undefined;
    console.log("Data reset");
    data = processResult(i, r);
    console.log("Data updated to:");
    console.log(untrack(() => $state.snapshot(data)));
    waiting = false;
  }

  async function lieClick(): Promise<Input> {
    // TODO format more comptly lie bracket
    const iii: Input = input != undefined ? input : ktInput;
    let tmp = JSON.stringify(
      {
        lie: {
          names: "lieNames",
          bracket: iii.lie.bracket
        },
        acs: {
          names: "acsNames",
          matrix: [
            ...Array(iii.acs.matrix.length)
              .keys()
              .map((i) => "acsMatrix-" + i)
          ],
          ...(iii.acs.norm != undefined && { norm: "acsNorm" })
        }
      },
      null,
      4
    )
      .replace('"lieNames"', JSON.stringify(iii.lie.names))
      .replace('"acsNames"', JSON.stringify(iii.acs.names));

    for (let i = 0; i < iii.acs.matrix.length; i++) {
      tmp = tmp.replace('"acsMatrix-' + i + '"', JSON.stringify(iii.acs.matrix[i]));
    }
    if (iii.acs.norm != undefined) {
      tmp = tmp.replace('"acsNorm"', JSON.stringify(iii.acs.norm));
    }
    modalLie = tmp;
    showModal = true;

    return new Promise((resolve, reject) => {
      modalSave = () => {
        if (modalLie === undefined) {
          reject("TODO Error, aborted");
          return;
        }
        let a = JSON.parse(modalLie);
        const newInput: Input = {
          dim: a.lie.names.length,
          ...a
        };
        const inputHash: string = hashInput(newInput);
        if (inputHash in precomputedExamples) {
          inputOption = precomputedExamples[inputHash].id;
        } else {
          inputOption = MoreMoreOptions.SELECTED_CUSTOM;
        }
        resolve(newInput);
      };
      modalAbort = () => {
        reject("Error, aborted");
      };
    });
  }

  $effect(() => {
    if (input === undefined) {
      console.log("Input reset");
      result = undefined;
      console.log("Result reset");
      data = undefined;
      console.log("Data reset");
      inputOption = MoreMoreOptions.DEFAULT;
      console.log("Input option reset");
    }
  });

  $effect(() => {
    if (inputHash != undefined && input != undefined) {
      if (result === undefined || inputHash != result.hash) {
        console.log("Input hash updated to:");
        console.log($state.snapshot(inputHash));
        console.log("Compute result...");
        computeResult(input);
      }
    }
  });

  $effect(() => {
    if (result != undefined && input != undefined && inputHash === result.hash) {
      console.log("Load data...");
      loadData(input, result);
    }
  });
</script>

<section class={input != undefined ? (data != undefined ? "loaded entered" : "entered") : ""}>
  <div id="input-parent">
    <div id="intro">
      <p>
        <strong>bicoCalculator</strong> is aimed at computing and displaying invariants of bigraded complexes,
        in particular from complex nilmanifolds. Its main goals are the computation of:
      </p>
      <ul>
        <li>Anti-Dolbeault, Bott-Chern and Aeppli cohomologies</li>
        <li>Zigzags and squares decomposition</li>
        <li>Frölicher spectral sequence</li>
      </ul>
      <p>
        Select one of the provided <strong>examples</strong> or the option to
        <strong>enter your own</strong> nilmanifold:
      </p>
    </div>
    <div id="input">
      <form>
        <label for="input-option">Selected nilmanifold:</label>
        <select id="input-option" bind:value={inputOption} onchange={setInputOption}>
          <option value={MoreMoreOptions.DEFAULT} selected disabled hidden>Choose here</option>
          <option value={MoreMoreOptions.SELECTED_CUSTOM} disabled hidden>Custom nilmanifold</option
          >
          {#each Object.entries(inputOptions) as [key, option]}
            <option value={key}>
              {option.label}
            </option>
          {/each}
        </select>
      </form>
      {#if input != undefined}
        <div class="visual">
          <div class="visualheader">
            <div><h5>Real Lie algebra</h5></div>
            <Button label="Edit" onClick={onEdit} slim={true} />
          </div>
          <div class="visualcontent">
            {@html math("\\Lambda(" + input.lie.names.join(", ") + ")")}
            <div id="brackets">
              {#each Object.entries(input.lie.bracket) as [key, value]}
                {@const k = key
                  .substring(1, key.length - 1)
                  .split(",")
                  .map((b) => parseInt(b.trim()))}
                {@const names = input.lie.names}
                {@html math(
                  "[" +
                    names[k[0] - 1] +
                    ", " +
                    names[k[1] - 1] +
                    "] = " +
                    Object.entries(value)
                      .map(
                        ([kk, vv], ii) =>
                          (vv < 0 ? "-" : ii != 0 ? "+" : "") + names[parseInt(kk) - 1]
                      )
                      .join(" ")
                )}
              {/each}
            </div>
          </div>
          <div class="visualheader">
            <h5>Almost complex structure</h5>
          </div>
          <div class="visualcontent">
            {@html math(
              "\\begin{pmatrix}" +
                input.acs.matrix.map((row) => row.join(" & ")).join(" \\\\") +
                "\\end{pmatrix}"
            )}
          </div>
        </div>
      {/if}
    </div>
  </div>
  <div id="acknowledgments">TODO acknowledgments</div>
</section>

<Modal
  bind:showModal
  buttonLabel="Save"
  buttonDisabled={saveDisabled}
  onClose={modalSave}
  onAbort={modalAbort}
>
  {#snippet header()}
    <h2>Edit the complex nilmanifold</h2>
  {/snippet}

  <textarea bind:value={modalLie}></textarea>
</Modal>

<style>
  section {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    /* justify-content: space-around; */
    width: 24rem;
    /* min-width: 30%; */
    background: var(--color-background);
    box-shadow:
      3px 0 1px -2px rgba(0, 0, 0, 0.2),
      3px 0 5px 0 rgba(0, 0, 0, 0.12),
      3px 0 2px 0 rgba(0, 0, 0, 0.14);
    padding: 1rem 1.5rem;
    gap: 0.8rem;
    height: 100%;
    /* min-height: 100%;
    overflow: auto;
    scrollbar-gutter: stable;
    max-height: fit-content; */
  }

  #input-parent {
    display: flex;
    flex-direction: column;
    width: 100%;
    gap: 0.8rem;
    /* min-height: 100%; */
    overflow: auto;
    scrollbar-gutter: stable;
    max-height: fit-content;
  }

  @media screen and (max-width: 768px) {
    section {
      width: 100%;
      z-index: 10;
      height: 100%;
      /* position: absolute; */
      /* top: 0; */
      /* bottom: 0; */
      /* transition: height .5s; */
      /* transition: flex-grow 0.15s ease-out; */
      /* transition: flex-grow 1s; */
      /* transition: flex-grow 1s ease-out; */
      /* flex-grow: 1; */
      /* height: 100%; */
      /* min-height: initial; */
      /* transition: top 0.5s; */
    }

    section.entered {
      /* height: fit-content; */
      height: 40%;
      /* flex-grow: 0; */
    }

    section.entered > :last-child {
      display: none;
    }

    section.entered .visualheader > :global(button) {
      display: none;
    }
  }

  section #input > form > label {
    display: none;
  }

  section #input > form {
    display: flex;
    flex-direction: row;
    justify-content: center;
    margin-bottom: 0.5rem;
    align-items: center;
  }

  section.entered #input > form > label {
    display: initial;
    margin-right: 0.8em;
  }

  section.entered #intro {
    display: none;
  }

  #intro p {
    text-align: justify;
    /* word-break: break-all; */
    text-wrap: pretty;
  }

  #input {
    display: flex;
    flex-direction: column;
    gap: 0.3rem;
  }

  h2 {
    font-size: medium;
    font-weight: bold;
    text-align: center;
  }

  .visual {
    display: flex;
    flex-direction: column;
    padding: 5px 8px;
    border: 1px rgb(134, 134, 134) solid;
    border-radius: 8px;
    /* align-items: center; */
  }

  .visualheader {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
  }

  p,
  h2,
  h5 {
    margin: 0;
  }

  h5 {
    padding: 3px 8px;
  }

  .visualcontent {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    margin: 3px 0 5px 0;
  }

  #brackets {
    display: flex;
    flex-direction: column;
    flex-wrap: wrap;
    margin-left: 1rem;
  }

  textarea {
    resize: none;
    width: 400px;
    height: 350px;
  }

  /* select,
  ::picker(select) {
    appearance: base-select;
  } */

  select {
    background-color: var(--color-accent-light);
    border: 1px solid transparent;
    padding: 5px 10px;
    transition: 0.4s;
    /* font-size: 1em; */
    font-weight: 500;
    font-family: inherit;
    border-radius: 4px;
    transition: border-color 0.25s;
  }

  select:hover,
  select:focus {
    border: 1px var(--color-accent-strong) solid;
  }

  select:disabled:hover,
  select:disabled:focus {
    border: 1px solid transparent;
  }

  select:active {
    border: 1px solid transparent;
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  ::picker(select) {
    border: none;
  }

  option::checkmark {
    content: "";
  }

  option:hover,
  option:focus {
    /* border: 1px var(--color-accent-strong) solid; */
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  option:checked {
    /* border: 1px solid transparent; */
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  option {
    /* border: 2px solid var(--color-accent-strong); */
    background-color: var(--color-accent-light);
    /* padding: 10px;
    transition: 0.4s; */
  }
</style>
