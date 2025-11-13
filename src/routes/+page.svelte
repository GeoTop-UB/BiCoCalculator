<script lang="ts">
  import { resolve } from "$app/paths";
  import favicon from "$lib/images/favicon.svg";
  import github from "$lib/images/github.svg";
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
  <title>BiCoCalculator</title>
  <meta
    name="description"
    content="An application aimed at computing invariants of bigraded complexes, in particular from complex nilmanifolds"
  />
</svelte:head>

<div id="app">
  <header>
    <div class="content" data-sveltekit-reload>
      <a href={resolve("/")} rel="noreferrer">
        <img src={favicon} class="logo" alt="BiCoCalculator" />
      </a>
      <a href={resolve("/")} rel="noreferrer">
        <h1>BiCoCalculator</h1>
      </a>
      <a id="sourcecode" href="https://github.com/GeoTop-UB/BiCoCalculator" target="_blank" rel="noreferrer">
        <img src={github} alt="Source code of this web application" />
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
    min-height: 100dvh;
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
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
    margin: auto;
    max-width: 100vw;
    width: max(calc(100dvh - 5rem + 24rem + 12rem + 1.5rem), 40rem + 24rem + 12rem + 1.5rem);
  }

  header h1 {
    font-family: "Momo Trust Display", sans-serif;
    font-weight: 400;
    /* font-family: "Montserrat", sans-serif;
    font-optical-sizing: auto;
    font-weight: 700; */
    font-style: normal;
    letter-spacing: 3px;
    color: var(--color-accent-stronger);
    margin: 0;
    margin: 1rem 0;
    font-size: 2rem;
    line-height: 1.5;
  }

  header .logo {
    height: 3rem;
    margin-right: 1.5rem;
  }

  main {
    /* flex: 1 1 auto; */
    display: flex;
    height: calc(100dvh - 2rem - 1.5 * 2rem);
  }

  .content {
    /* max-width: 1280px; */
    width: max-content;
  }

  #sourcecode {
    position: absolute;
    right: 0;
  }

  #sourcecode img {
    height: 2.5rem;
  }

  @media screen and (max-width: calc(40rem + 24rem + 12rem + 2.5em)) {
    #sourcecode {
      margin-right: 1em;
    }
  }

  @media screen and (max-width: 768px) {
    .content {
      width: 100%;
    }

    main {
      flex-direction: column-reverse;
    }

    #sourcecode {
      display: none;
    }
  }
</style>
