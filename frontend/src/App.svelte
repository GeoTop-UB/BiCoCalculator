<script>
  import svelteLogo from './assets/svelte.svg'
  import viteLogo from '/vite.svg'
  import Counter from './lib/Counter.svelte'
  import KT from './assets/KT.json'
  import { math, display } from 'mathlifier';

  // const apiUrl = "http://127.0.0.1:5001/";
  
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
    {
      "id": "squares",
      "name": "Squares",
      "type": "squares",
    }
  ];
  let data = $state();
  let number = $state();
  let n = $state();
  let tab = $state(tabs[0]["id"])

	async function roll() {
    number = data["cohomology_aeppli"]["(1, 1)"];
	}

  function a() {
    n = 2;
  }

  function compare(a, b){
    const ka = a[0].substring(1, a[0].length - 1).split(",").map(s => parseInt(s.trim()));
    const kb = b[0].substring(1, b[0].length - 1).split(",").map(s => parseInt(s.trim()));
    if (ka[1] > kb[1]) {
      return -1;
    } else if (ka[1] < kb[1]) {
      return 1;
    } else if (ka[0] < kb[0]) {
      return -1
    } else if (ka[0] > kb[0]) {
      return 1;
    }
    return 0;
  }

  // const response = await fetch(apiUrl);
  // data = await response.json();
  data = {
    // "n": KT.n,
    // "m": KT.m,
    "cohomology_aeppli": KT.cohomology.aeppli,
    "cohomology_bottchern": KT.cohomology.bottchern,
    "cohomology_delbar": KT.cohomology.delbar,
    "cohomology_dell": KT.cohomology.dell,
    "cohomology_reduced_aeppli": KT.cohomology.reduced_aeppli,
    "cohomology_reduced_bottchern": KT.cohomology.reduced_bottchern,
    "zigzags": KT.zigzags,
    "squares": KT.squares
  };
  n = KT.n;

  $inspect(data)
</script>

<main style="--n: {n}">
  <div id="top-bar">
    <div class="content">
      <h1>bbCalculator</h1>
    </div>
  </div>
  <div class="content">
    <div id="input">
      
      <p>n = </p>
      <label>
        <input type="number" bind:value={n} min="0" />
        <input type="range" bind:value={n} min="0" />
      </label>

      <div>
        <a href="https://vite.dev" target="_blank" rel="noreferrer">
          <img src={viteLogo} class="logo" alt="Vite Logo" />
        </a>
      </div>

      <div class="card">
        <Counter />
      </div>

      
      <p>Kodaira-Thurston manifold</p>
      <button onclick={roll}>Roll the dice {@html math('A = \\pi r^2')}</button>

      {#if number !== undefined}
        <p>You rolled a {number}</p>
      {/if}
    </div>
    <div id="output">
      <div class="tab">
        {#each tabs as t}
          <button class="tablinks" onclick={() => tab = t.id}>{t.name}</button>
        {/each}
      </div>

      <div id="output2">
      <!-- TODO reorder list to mach expected table of cohomology -->
      {#each Object.entries(data[tab]).sort(compare) as [key, value]}
        {@const dim = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
        {#if dim[0] == 0}
          <div>{dim[1]}</div>
        {/if}
        <div>{@html value.map(b => math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")))}</div>
      {/each}
      <div></div>
      {#each [...Array(n).keys()] as key}
        <div>{key}</div>
      {/each}
      </div>
    </div>
  </div>
</main>

<style>
  main {
    margin: 0;
    display: flex;
    flex-direction: column;
    place-items: center;
    min-width: 320px;
    min-height: 100vh;
  }

  #output {
    width: 60%;
    margin: 1rem;
  }

  #output2 {
    display: grid;
    grid-template-columns: 1fr repeat(var(--n), 3fr);
    grid-template-rows: repeat(var(--n), 3fr) 1fr;
    padding: 10px;
    align-items: center;
    justify-items: center;
    /* aspect-ratio: 1 / 1; */
  }

  #output2 > div {
    border: 1px black dashed;
    padding: 10px;
    width: 100%;
    height: 100%;
    display: flex;
    /* flex-direction: column; */
    align-items: center;
    justify-content: center;
  }

  #input {
    width: 40%;
    border-right: 1px black solid;
  }

  main > .content {
    padding: 2rem;
    display: flex;
  }

  #top-bar {
    width: 100vw;
    background-color: darkslateblue;
    /* height: 5em; */
    color: white;
    margin-bottom: 1.5rem;
  }

  .content {
    max-width: 1280px;
    width: 90%;
    margin: 0 auto;
    text-align: center;
  }

  .logo {
    height: 6em;
    padding: 1.5em;
    will-change: filter;
    transition: filter 300ms;
  }

  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
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
