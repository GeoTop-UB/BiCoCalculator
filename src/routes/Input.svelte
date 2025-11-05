<script lang="ts">
  import { math } from "mathlifier";

  import { compute, findExample } from "$lib/compute";
  import Modal from "$lib/components/Modal.svelte";
  import Button from "$lib/components/Button.svelte";
  import ktInput from "$lib/precomputations/KT_Input.json";
  import iwInput from "$lib/precomputations/IW_Input.json";
  // import jnInput from "$lib/precomputations/JN_Input.json";

  let { data = $bindable(), waiting = $bindable(), isMobile } = $props();

  interface LieBracket {
    [result: string]: number;
  }
  interface LieBrackets {
    [bidegree: string]: LieBracket;
  }
  interface Input {
    dim: number;
    lie: {
      names: string[];
      bracket: LieBrackets;
    };
    acs: {
      names: string[];
      matrix: number[][];
      norm?: number[];
    };
  }
  // interface Data {
  //   n: number;
  //   m: number;
  //   cohomology: {
  //     dell: Cohomology;
  //     delbar: Cohomology;
  //     bottchern: Cohomology;
  //     aeppli: Cohomology;
  //     reduced_aeppli: Cohomology;
  //     reduced_bottchern: Cohomology;
  //   };
  //   zigzags: ZigZag[];
  //   squares: ZigZag[];
  // }

  let input: Input | undefined = $state.raw();
  let ktActive = $state(false);
  let iwActive = $state(false);
  let showModal = $state(false);
  let modalLie = $state();

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

  async function setKt() {
    if (!ktActive) {
      input = ktInput;
      ktActive = true;
      iwActive = false;
    }
  }

  async function setIw() {
    if (!iwActive) {
      input = iwInput;
      ktActive = false;
      iwActive = true;
    }
  }

  async function loadData(input: Input) {
    data = undefined;
    waiting = true;
    data = await compute(
      input.dim,
      input.lie.bracket,
      input.acs.names,
      input.acs.matrix,
      input.acs.norm
    );
    waiting = false;
  }

  async function editMobile() {
    data = undefined;
  }

  async function lieClick() {
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
  }

  async function save() {
    let a = JSON.parse(modalLie);
    const newInput: Input = {
      dim: a.lie.names.length,
      ...a
    };
    input = newInput;
    const ex = findExample(newInput);
    if (ex === "KT") {
      ktActive = true;
      iwActive = false;
    } else if (ex === "IW") {
      ktActive = false;
      iwActive = true;
    } else {
      ktActive = false;
      iwActive = false;
    }
    return true;
  }

  $effect(() => {
    if (input != undefined) {
      console.log("Input updated to:");
      console.log($state.snapshot(input));
      loadData(input);
    } else {
      console.log("Input reset");
      data = undefined;
    }
  });

  $effect(() => {
    if (data != undefined) {
      console.log("Data updated to:");
      console.log($state.snapshot(data));
    } else {
      console.log("Data reset");
    }
  });
</script>

<section class={data != undefined ? "loaded" : ""}>
  <div id="intro">
    <p>
      <strong>bbCalculator</strong> is aimed at computing invariants of bigraded complexes, in particular
      from complex nilmanifolds.
    </p>
  </div>
  <div id="examples">
    <h2>Some examples to try:</h2>
    <div>
      <Button label="Kodaira-Thurston" onClick={setKt} bind:active={ktActive} />
      <Button label="Iwasawa" onClick={setIw} bind:active={iwActive} />
    </div>
  </div>
  {#if input != undefined}
    <div id="input">
      {#if isMobile && data != undefined}
        <Button label="Complex nilmanifold: ✏️" onClick={editMobile} slim={true} />
      {:else}
        <h2>Complex nilmanifold:</h2>
      {/if}
      <div class="visual">
        <div class="visualheader">
          <div><h5>Real Lie algebra</h5></div>
          <Button label="Edit" onClick={lieClick} slim={true} />
        </div>
        <div class="visualcontent">
          {@html math("\\Lambda(" + input.lie.names.join(", ") + ")")}
          <div id="brackets">
            {#each Object.entries(input.lie.bracket) as [key, value]}
              {@const k = key
                .substring(1, key.length - 1)
                .split(",")
                .map((b) => parseInt(b.trim()))}
              {@html math(
                "[" +
                  input.lie.names[k[0] - 1] +
                  ", " +
                  input.lie.names[k[1] - 1] +
                  "] = " +
                  Object.entries(value)
                    .map(
                      ([kk, vv], ii) =>
                        (vv < 0 ? "-" : ii != 0 ? "+" : "") + input.lie.names[parseInt(kk) - 1]
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
    </div>
  {/if}
</section>

<Modal bind:showModal buttonLabel="Save" buttonDisabled={saveDisabled} onClose={save}>
  {#snippet header()}
    <h2>Edit the complex nilmanifold</h2>
  {/snippet}

  <textarea bind:value={modalLie}></textarea>
</Modal>

<style>
  section {
    display: flex;
    flex-direction: column;
    /* justify-content: space-between; */
    justify-content: space-around;
    width: 30%;
    min-width: 30%;
    box-shadow:
      3px 0 1px -2px rgba(0, 0, 0, 0.2),
      3px 0 5px 0 rgba(0, 0, 0, 0.12),
      3px 0 2px 0 rgba(0, 0, 0, 0.14);
    padding: 1rem 1.5rem;
    gap: 0.8rem;
    min-height: 100%;
    overflow: auto;
    scrollbar-gutter: stable;
    max-height: fit-content;
  }

  @media screen and (max-width: 768px) {
    section {
      width: 100%;
      z-index: 10;
      /* position: absolute; */
      /* top: 0; */
      /* bottom: 0; */
      /* transition: height .5s; */
      /* transition: flex-grow 0.15s ease-out; */
      transition: flex-grow 1s;
      /* transition: flex-grow 1s ease-out; */
      flex-grow: 1;
      background: white;
      /* height: 100%; */
      min-height: initial;
      /* transition: top 0.5s; */
    }

    section.loaded {
      height: fit-content;
      max-height: 40%;
      flex-grow: 0;
    }

    section.loaded > #intro {
      display: none;
    }

    section.loaded > #examples {
      display: none;
    }

    section.loaded > :global(*):last-child {
      display: none;
    }

    section.loaded .visualheader > :global(button) {
      display: none;
    }
  }

  #intro p {
    text-align: justify;
    /* word-break: break-all; */
    text-wrap: pretty;
  }

  #examples,
  #input {
    display: flex;
    flex-direction: column;
    gap: 0.3rem;
  }

  #examples > div {
    display: flex;
    flex-direction: row;
    justify-content: center;
    gap: 1rem;
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
</style>
