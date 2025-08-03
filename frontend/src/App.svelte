<script>
  // import svelteLogo from './assets/svelte.svg'
  import viteLogo from '/vite.svg'
  import Output from './lib/Output.svelte';
  import KT from './assets/KT.json'
  import { math } from 'mathlifier';
    
  // import { draw } from 'svelte/transition';

  // const apiUrl = "http://127.0.0.1:5001/";

  let data = $state();
  let number = $state();
  let n = $state();

	async function roll() {
    number = data["cohomology_aeppli"]["(1, 1)"];
	}

  // const response = await fetch(apiUrl);
  // KT = await response.json();
  data = {
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
  // m = KT.m;
</script>

<main>
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

      <!-- <div class="card">
        <Counter />
      </div> -->

      
      <p>Kodaira-Thurston manifold</p>
      <button onclick={roll}>Roll the dice {@html math('A = \\pi r^2')}</button>

      {#if number !== undefined}
        <p>You rolled a {number}</p>
      {/if}
    </div>
    <Output {data} {n} />
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
</style>
