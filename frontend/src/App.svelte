<script>
  import Input from './lib/Input.svelte';
  import Output from './lib/Output.svelte';

  let data = $state();
</script>

<main>
  <div id="top-bar">
    <div class="content">
      <h1>bbCalculator</h1>
    </div>
  </div>
  <div class="content">
    <Input bind:data />
    <Output {data} />
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
</style>
