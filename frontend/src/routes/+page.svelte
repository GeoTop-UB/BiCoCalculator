<script lang="ts">
  import { base } from '$app/paths';
  import favicon from "$lib/images/favicon.svg";
  import Input from "./Input.svelte";
  import Output from "./Output.svelte";
  import '../app.css';

  let data = $state();
  let waiting: boolean = $state(false);
</script>

<svelte:head>
    <title>bbCalculator</title>
	<meta name="description" content="Svelte demo app" />
</svelte:head>

<div id="app">
  <header>
    <div class="content">
      <a href="{base}/" target="_blank" rel="noreferrer">
        <img src={favicon} class="logo" alt="bbCalculator" />
      </a>
      <a href="{base}/" target="_blank" rel="noreferrer">
        <h1>bbCalculator</h1>
      </a>
    </div>
  </header>
  <main class="content">
    <Input bind:data bind:waiting />
    <Output {data} {waiting} />
  </main>
</div>

<style>
  #app {
    margin: 0;
    display: flex;
    flex-direction: column;
    place-items: center;
    min-width: 320px;
    min-height: 100vh;
  }

  header {
    flex: 0 1 auto;
    width: 100vw;
    box-shadow:
      0 2px 2px 0 rgba(0, 0, 0, 0.14),
      0 1px 5px 0 rgba(0, 0, 0, 0.12),
      0 3px 1px -2px rgba(0, 0, 0, 0.2);
  }

  main {
    flex: 1 1 auto;
    display: flex;
  }

  .content {
    max-width: 1280px;
    width: 100%;
  }

  header > .content {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: auto;
  }

  header h1 {
    font-family: "Montserrat", sans-serif;
    font-optical-sizing: auto;
    font-weight: 700;
    font-style: normal;
    letter-spacing: 3px;
    color: var(--color-accent-stronger);
  }

  header img {
    height: 3rem;
    margin-right: 1.5rem;
  }
</style>
