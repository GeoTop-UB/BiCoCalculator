<script>
  import { math } from 'mathlifier';
  import KT from '../assets/KT.json'
  import StickyButton from './StickyButton.svelte';
  import Modal from './Modal.svelte';
  import Button from './Button.svelte';

  let { data = $bindable(), waiting = $bindable() } = $props();
  
  const apiUrl = "http://127.0.0.1:5001/";
  const kte = {
    "dim": 4,
    "lie": {
      "names": ["X", "Y", "Z", "W"],
      "bracket": {
        "(1, 2)": {"3": -1}
      }
    },
    "acs": {
      "names": ["a", "b", "\\bar{a}", "\\bar{b}"],
      "matrix": [
        [0,-1,0,0],
        [1,0,0,0],
        [0,0,0,-1],
        [0,0,1,0]
      ],
      "norm": undefined
    }
  };
  const iwe = {
    "dim": 6,
    "lie": {
      "names": ["p", "ip", "q", "iq", "z", "iz"],
      "bracket": {
        "(1, 3)": {"5": 1},
        "(1, 4)": {"6": 1},
        "(2, 3)": {"6": 1},
        "(2, 4)": {"5": -1}
      }
    },
    "acs": {
      "names": ["a", "b", "c", "\\bar{a}", "\\bar{b}", "\\bar{c}"],
      "matrix": [
        [0,1,0,0,0,0],
        [-1,0,0,0,0,0],
        [0,0,0,1,0,0],
        [0,0,-1,0,0,0],
        [0,0,0,0,0,1],
        [0,0,0,0,-1,0]
      ],
      "norm": [0.5,1,1,0.5,1,1]
    }
  };

  let dim = $state(kte.dim);
  let lieNames = $state(kte.lie.names);
  let lieBracket = $state.raw(kte.lie.bracket);
  let acsNames = $state(kte.acs.names);
  let acsMatrix = $state.raw(kte.acs.matrix);
  let acsNorm = $state(kte.acs.norm);
  let ktActive = $state(true);
  let iwActive = $state(false);
	let showModal = $state(false);
	let modalLie = $state();
  let computeDisabled = $state(false)

  let saveDisabled = $derived.by(() => {
    if (modalLie != undefined) {
      try {
        let a = JSON.parse(modalLie);
        if (
          Object.hasOwn(a, "lie") 
          && Object.hasOwn(a.lie, "names") 
          && Object.hasOwn(a.lie, "bracket") 
          && Object.hasOwn(a, "acs") 
          && Object.hasOwn(a.acs, "names") 
          && Object.hasOwn(a.acs, "matrix") 
          && a.lie.names.length === a.acs.names.length
          && a.lie.names.length === a.acs.matrix.length 
          // TODO add more checks
          // && a.lie.names.length === a.acs.matrix[0].length 
          // && a.lie.names.length === a.acs.norm.length 
        ) {
          return false;
        }
      } catch (exceptionVar) {}
    }
    return true;
  })

  const kteBr = JSON.stringify(kte.lie.bracket);
  const kteJ = kte.acs.matrix.toString();
  const iweBr = JSON.stringify(iwe.lie.bracket);
  const iweJ = iwe.acs.matrix.toString();
  // let ktActive = $derived(dim === kte.dim && JSON.stringify(lieBracket) === kteBr && acsMatrix.toString() === kteJ);
  // let iwActive = $derived(dim === iwe.dim && JSON.stringify(lieBracket) === iweBr && acsMatrix.toString() === iweJ);

  async function setKt() {
    if (!ktActive) {
      data = undefined;
      dim = kte.dim;
      lieNames = kte.lie.names;
      lieBracket = kte.lie.bracket;
      acsNames = kte.acs.names;
      acsMatrix = kte.acs.matrix;
      acsNorm = kte.acs.norm;
      computeDisabled = false;
      ktActive = true;
      iwActive = false;
    }
  }

  async function setIw() {
    if (!iwActive) {
      data = undefined;
      dim = iwe.dim;
      lieNames = iwe.lie.names;
      lieBracket = iwe.lie.bracket;
      acsNames = iwe.acs.names;
      acsMatrix = iwe.acs.matrix;
      acsNorm = iwe.acs.norm;
      computeDisabled = false;
      ktActive = false;
      iwActive = true;
    }
  }

  async function loadData() {
    computeDisabled = true;
    waiting = true;
    const response = await fetch(apiUrl, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      method: "POST",
      body: JSON.stringify({
        "dim": dim,
        "lie": {
          "names": lieNames,
          "bracket": lieBracket
        },
        "acs": {
          "names": acsNames,
          "matrix": acsMatrix,
          ...(acsNorm != undefined) && {"norm": acsNorm}
        }
      })
    });
    let d = await response.json();
    data = {
      "n": d.n,
      "m": d.m,
      "cohomology_aeppli": d.cohomology.aeppli,
      "cohomology_bottchern": d.cohomology.bottchern,
      "cohomology_delbar": d.cohomology.delbar,
      "cohomology_dell": d.cohomology.dell,
      "cohomology_reduced_aeppli": d.cohomology.reduced_aeppli,
      "cohomology_reduced_bottchern": d.cohomology.reduced_bottchern,
      "zigzags": ktActive? KT.zigzags : d.zigzags,
      "squares": d.squares
    };
    waiting = false;
  }

  async function lieClick() {
    // TODO format more comptly lie bracket
    let tmp = JSON.stringify({
      "lie": {
        "names": "lieNames",
        "bracket": lieBracket
      },
      "acs": {
        "names": "acsNames",
        "matrix": [...Array(acsMatrix.length).keys().map((i) => "acsMatrix-" + i)],
        ...(acsNorm != undefined) && {"norm": "acsNorm"}
      }
    }, null, 4).replace(
      "\"lieNames\"", JSON.stringify(lieNames)
    ).replace(
      "\"acsNames\"", JSON.stringify(acsNames)
    );
    
    for (let i = 0; i < acsMatrix.length; i++) {
      tmp = tmp.replace(
        "\"acsMatrix-" + i + "\"", JSON.stringify(acsMatrix[i])
      );
    }
    if (acsNorm != undefined) {
      tmp = tmp.replace("\"acsNorm\"", JSON.stringify(acsNorm));
    }
    modalLie = tmp;
	  showModal = true;
  }

  async function save() {
    let a = JSON.parse(modalLie);
    data = undefined;
    dim = a.lie.names.length;
    lieNames = a.lie.names;
    lieBracket = a.lie.bracket;
    acsNames = a.acs.names;
    acsMatrix = a.acs.matrix;
    acsNorm = a.acs.norm;
    computeDisabled = false;
    if (dim === kte.dim && JSON.stringify(lieBracket) === kteBr && acsMatrix.toString() === kteJ) {
      ktActive = true;
      iwActive = false;
    } else if (dim === iwe.dim && JSON.stringify(lieBracket) === iweBr && acsMatrix.toString() === iweJ) {
      ktActive = false;
      iwActive = true;
    } else {
      ktActive = false;
      iwActive = false;
    }
    return true;
  }
</script>

<section>
  <div id="intro">
    <p><strong>bbCalculator</strong> is aimed at computing invariants of bigraded complexes, in particular from complex nilmanifolds.</p>
  </div>
  <div id="examples">
    <h2>Some examples to try:</h2>
    <div>
      <StickyButton label="Kodaira-Thurston" onClick={setKt} active={ktActive} disabled={false} />
      <StickyButton label="Iwasawa" onClick={setIw} active={iwActive} disabled={false} />
    </div>
  </div>
  <div id="input">
    <h2>Complex nilmanifold:</h2>
    <div class="visual">
      <div class="visualheader">
        <div><h5>Real Lie algebra</h5></div>
        <Button label="Edit" onClick={lieClick} slim={true} />
      </div>
      <div class="visualcontent">
        {@html math("\\Lambda(" + lieNames.join(", ") + ")")}
        <div id="brackets">
          {#each Object.entries(lieBracket) as [key, value]}
            {@const k = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
            {@html math("[" + lieNames[k[0] - 1] + ", " + lieNames[k[1] - 1] + "] = " + Object.entries(value).map(([kk, vv], ii) => (vv < 0? "-" : (ii != 0? "+" : "")) + lieNames[parseInt(kk) - 1]).join(" "))}
          {/each}
        </div>
      </div>
      <div class="visualheader">
        <h5>Almost complex structure</h5>
      </div>
      <div class="visualcontent">
        {@html math("\\begin{pmatrix}" + acsMatrix.map((row) => row.join(" & ")).join(" \\\\") + "\\end{pmatrix}")}
      </div>
    </div>
  </div>

  <Button label="Compute invariants" onClick={loadData} disabled={computeDisabled} />
</section>

<Modal bind:showModal buttonLabel="Save" buttonDisabled={saveDisabled} onClose={save}>
	{#snippet header()}
		<h2>
			Edit the complex nilmanifold
		</h2>
	{/snippet}

	<textarea bind:value={modalLie}></textarea>
</Modal>

<style>
  section {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    width: 30%;
    box-shadow: 3px 0 1px -2px rgba(0, 0, 0, .2), 3px 0 5px 0 rgba(0, 0, 0, .12), 3px 0 2px 0 rgba(0, 0, 0, .14);
    padding: 1rem 1.5rem;
    gap: 0.8rem;
  }

  #intro p {
    text-align: justify;
    /* word-break: break-all; */
    text-wrap: pretty;
  }

  #examples, #input {
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

  p, h2, h5 {
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
    margin-left: 1rem
  }
  
  textarea {
		resize: none;
    width: 400px;
    height: 350px;
	}
</style>