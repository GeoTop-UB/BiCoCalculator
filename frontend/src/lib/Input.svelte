<script>
  import { math } from 'mathlifier';
  import KT from '../assets/KT.json'
  import StickyButton from './StickyButton.svelte';

  let { data = $bindable() } = $props();
  
  const apiUrl = "http://127.0.0.1:5001/";
  const ktLie = "a";
  const ktJ = "a";
  // 'X,Y,Z,W', {
  //           ('X','Y'): {'Z':-1}
  //       }
  // [
  //               [0,-1,0,0],
  //               [1,0,0,0],
  //               [0,0,0,-1],
  //               [0,0,1,0]
  //           ]
  //            ['a', 'b', 'abar', 'bbar']
  const iwLie = "b";
  const iwJ = "b";
  //   'p,ip,q,iq,z,iz', {
  //             ('p','q'): {'z':1},
  //             ('p', 'iq'): {'iz':1},
  //             ('ip','q'): {'iz':1},
  //             ('ip', 'iq'): {'z':-1}
  //         }
  //   [
  //     [0,1,0,0,0,0],
  //     [-1,0,0,0,0,0],
  //     [0,0,0,1,0,0],
  //     [0,0,-1,0,0,0],
  //     [0,0,0,0,0,1],
  //     [0,0,0,0,-1,0]
  // ]`
  // ['a','b','c','abar','bbar','cbar']`

  let lie = $state("a");
  let j = $state("a");
  let ktActive = $state(true);
  let iwActive = $state(false);

  // let ktActive = $derived(lie === ktLie && j === ktJ);
  // let iwActive = $derived(lie === iwLie && j === iwJ);

  async function setKt() {
    if (lie != ktLie || j != ktJ) {
      data = undefined;
    }
    lie = ktLie;
    j = ktJ;
    ktActive = true;
    iwActive = false;
  }

  async function setIw() {
    if (lie != iwLie || j != iwJ) {
      data = undefined;
    }
    lie = iwLie;
    j = iwJ;
    ktActive = false;
    iwActive = true;
  }

  async function loadData() {
    // const response = await fetch(apiUrl);
    // KT = await response.json();
    data = {
      "n": KT.n,
      "m": KT.m,
      "cohomology_aeppli": KT.cohomology.aeppli,
      "cohomology_bottchern": KT.cohomology.bottchern,
      "cohomology_delbar": KT.cohomology.delbar,
      "cohomology_dell": KT.cohomology.dell,
      "cohomology_reduced_aeppli": KT.cohomology.reduced_aeppli,
      "cohomology_reduced_bottchern": KT.cohomology.reduced_bottchern,
      "zigzags": KT.zigzags,
      "squares": KT.squares
    };
  }
</script>

<section>
  <div>
    <p>TODO intro  is aimed at computing invariants of Bigraded Complexes</p>
  </div>
  <div id="examples">
    <StickyButton label="Kodaira-Thurston" onClick={setKt} active={ktActive} disabled={false} />
    <StickyButton label="Iwasawa" onClick={setIw} active={iwActive} disabled={false} />
  </div>
  <div>
    <p>Custom nilmanifold</p>
  </div>

  <button onclick={loadData}>Compute</button>
</section>

<style>
  section {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    width: 30%;
    box-shadow: 3px 0 1px -2px rgba(0, 0, 0, .2), 3px 0 5px 0 rgba(0, 0, 0, .12), 3px 0 2px 0 rgba(0, 0, 0, .14)
  }

  #examples {
    display: flex;
    flex-direction: row;
    justify-content: space-around;
  }

  button {
    background-color: rgb(255, 210, 255);
    border: 1px solid transparent;
  }

  button:hover {
    border: 1px rgb(180, 30, 180) solid;
  }
  
  button:active {
    border: 1px solid transparent;
    background-color: rgb(180, 30, 180);
    color: white;
  }
</style>