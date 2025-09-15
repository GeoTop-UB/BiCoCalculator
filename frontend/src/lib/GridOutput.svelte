<script>
  import { math } from "mathlifier";
  import ZigzagOutput from "./ZigzagOutput.svelte";

  let { datatab, n, type } = $props();

  function compare(a, b) {
    const ka = a[0]
      .substring(1, a[0].length - 1)
      .split(",")
      .map((s) => parseInt(s.trim()));
    const kb = b[0]
      .substring(1, b[0].length - 1)
      .split(",")
      .map((s) => parseInt(s.trim()));
    if (ka[1] > kb[1]) {
      return -1;
    } else if (ka[1] < kb[1]) {
      return 1;
    } else if (ka[0] < kb[0]) {
      return -1;
    } else if (ka[0] > kb[0]) {
      return 1;
    }
    return 0;
  }
</script>

<div id="output2" class={type} style="--n: {n}">
  {#each Object.entries(type === "zigzags" || type === "squares" ? datatab.basis : datatab).sort(compare) as [key, value]}
    {@const dim = key
      .substring(1, key.length - 1)
      .split(",")
      .map((b) => parseInt(b.trim()))}
    {@const notfirstrow = dim[1] != 0}
    {@const notfirstcol = dim[0] != 0}

    {#if dim[0] == 0}
      <div class="yidx">{dim[1]}</div>
    {/if}
    <div class={["cell", { notfirstrow }, { notfirstcol }]}>
      {#if type === "zigzags" || type === "squares"}
        <ZigzagOutput
          points={value.filter((b) => b.type === "point")}
          nopoints={value.filter((b) => b.type === "start" || b.type === "end")}
          tracks={datatab.tracks[key]}
        />
      {:else}
        <div class="cohomologycell">
          {@html value.map((b) => "<div>" + math(b) + "</div>").join("")}
        </div>
      {/if}
    </div>
  {/each}
  <div></div>
  {#each [...Array(n).keys()] as key}
    <div class="xidx">{key}</div>
  {/each}
</div>

<style>
  #output2 {
    display: grid;
    /* grid-template-columns: 1fr repeat(var(--n), 4fr);
    grid-template-rows: repeat(var(--n), 4fr) 1fr; */
    grid-template-columns: 1.2lh repeat(var(--n), minmax(15ex, max-content));
    grid-template-rows: repeat(var(--n), minmax(15ex, max-content)) 1.2lh;
    /* align-items: center;
    justify-items: center; */
    padding: 1rem;
    /* max-width: 100%; */
    /* width: max-content; */
    /* height: max-content; */
    aspect-ratio: 1 / 1;
  }

  .xidx,
  .yidx {
    padding: 5px 8px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .yidx {
    border-right: 1px black solid;
  }

  .xidx {
    border-top: 1px black solid;
  }

  .notfirstrow {
    border-bottom: 1px black dashed;
  }

  .notfirstcol {
    border-left: 1px black dashed;
  }

  #output2 {
    --node-size: 1.25ex;
  }

  .cell {
    height: 100%;
  }

  .cohomologycell {
    padding: 5px 8px;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
  }

  #output2.zigzags {
    min-width: max-content;
  }
</style>
