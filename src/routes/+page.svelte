<script lang="ts">
  import { resolve } from "$app/paths";
  import favicon from "$lib/images/favicon.svg";
  import Input from "./Input.svelte";
  import Output from "./Output.svelte";
  import "../app.css";
  import type { Data, Input as InputType } from "$lib/compute";

  let data: Data | undefined = $state();
  let input: InputType | undefined = $state.raw();
  let waiting: boolean = $state(false);
  let error: string | undefined = $state();

  let entered = $derived(input != undefined);
</script>

<svelte:head>
  <title>bicoCalculator</title>
  <meta
    name="description"
    content="An application aimed at computing invariants of bigraded complexes, in particular from complex nilmanifolds"
  />
</svelte:head>

<div id="app">
  <header>
    <div class="content" data-sveltekit-reload>
      <a href={resolve("/")} rel="noreferrer">
        <img src={favicon} class="logo" alt="bicoCalculator" />
      </a>
      <a href={resolve("/")} rel="noreferrer">
        <h1>bicoCalculator</h1>
      </a>
    </div>
  </header>
  <main class="content">
    <Input bind:input bind:data bind:waiting bind:error />
    <Output {data} {waiting} {entered} {error} />
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
    /* flex: 0 1 auto; */
    width: 100vw;
    background: var(--color-background);
    box-shadow:
      0 2px 2px 0 rgba(0, 0, 0, 0.14),
      0 1px 5px 0 rgba(0, 0, 0, 0.12),
      0 3px 1px -2px rgba(0, 0, 0, 0.2);
    z-index: 100;
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
    margin: 0;
    margin: 1rem 0;
    font-size: 2rem;
    line-height: 1.5;
  }

  header img {
    height: 3rem;
    margin-right: 1.5rem;
  }

  main {
    /* flex: 1 1 auto; */
    display: flex;
    height: calc(100vh - 2rem - 1.5 * 2rem);
  }

  .content {
    /* max-width: 1280px; */
    width: max-content;
  }

  @media screen and (max-width: 768px) {
    .content {
      width: 100%;
    }

    main {
      flex-direction: column-reverse;
    }
  }
</style>
