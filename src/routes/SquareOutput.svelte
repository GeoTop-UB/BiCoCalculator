<script lang="ts">
  import { math } from "mathlifier";

  import type { SquareCoord, Squares } from "$lib/compute/types";

  interface Props {
    points: SquareCoord[][];
  }
  let { points }: Props = $props();

  let swPoints = $derived(points[0]);
  let sePoints = $derived(points[1]);
  let nwPoints = $derived(points[2]);
  let nePoints = $derived(points[3]);

  function adjustLine(from, to, line, vertical) {
    const remToPx = parseFloat(getComputedStyle(document.documentElement).fontSize);
    const marginRem = parseFloat(getComputedStyle(line).getPropertyValue("--margin-hover"));
    const margin = marginRem * remToPx;

    const fT = from.offsetTop + from.offsetHeight / 2;
    const tT = to.offsetTop + to.offsetHeight / 2;
    const fL = from.offsetLeft + from.offsetWidth / 2;
    const tL = to.offsetLeft + to.offsetWidth / 2;

    const px = "px";
    if (vertical) {
      line.style.top = tT - margin + px;
      line.style.left = tL - margin - 1 + px;
      line.style.height = fT - tT + 2 * margin + px;
    } else {
      line.style.top = fT - margin - 1 + px;
      line.style.left = fL - margin + px;
      line.style.width = tL - fL + 2 * margin + px;
    }
  }

  function myaction(node, { v, w, vertical }) {
    $effect(() => {
      adjustLine(document.getElementById(v), document.getElementById(w), node, vertical);

      return () => {};
    });
  }
</script>

<div id="cell">
  <div id="sw" class="points" style="--n-points: {swPoints.length}">
    {#each swPoints.entries() as [i, b]}
      {@const id = "sq-sw-" + i}
      <div id="aaa" use:myaction={{ v: id, w: "sq-nw-" + i, vertical: true }}>
        <div class="line linev"></div>
        <span class="tooltiptext ver zigzagtool">
          <div class="zigzagnodetool" style="grid-area: sw">
            <div>{@html math(b.square[0])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: se">
            <div>{@html math(b.square[1])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: nw">
            <div>{@html math(b.square[2])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: ne">
            <div>{@html math(b.square[3])}</div>
          </div>
        </span>
      </div>
      <div id="aaa" use:myaction={{ v: id, w: "sq-se-" + i, vertical: false }}>
        <div class="line lineh"></div>
        <span class="tooltiptext hor zigzagtool">
          <div class="zigzagnodetool" style="grid-area: sw">
            <div>{@html math(b.square[0])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: se">
            <div>{@html math(b.square[1])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: nw">
            <div>{@html math(b.square[2])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: ne">
            <div>{@html math(b.square[3])}</div>
          </div>
        </span>
      </div>
      <div {id} class="node" style="grid-area: {-(i + 1)} / {i + 1} / {-(i + 2)} / {i + 2};"></div>
    {/each}
  </div>
  <div id="nw" class="points" style="--n-points: {nwPoints.length}">
    {#each nwPoints.entries() as [i, b]}
      {@const id = "sq-nw-" + i}
      <div id="aaa" use:myaction={{ v: id, w: "sq-ne-" + i, vertical: false }}>
        <div class="line lineh"></div>
        <span class="tooltiptext hor zigzagtool">
          <div class="zigzagnodetool" style="grid-area: sw">
            <div>{@html math(b.square[0])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: se">
            <div>{@html math(b.square[1])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: nw">
            <div>{@html math(b.square[2])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: ne">
            <div>{@html math(b.square[3])}</div>
          </div>
        </span>
      </div>
      <div {id} class="node" style="grid-area: {-(i + 1)} / {i + 1} / {-(i + 2)} / {i + 2};"></div>
    {/each}
  </div>
  <div id="se" class="points" style="--n-points: {sePoints.length}">
    {#each sePoints.entries() as [i, b]}
      {@const id = "sq-se-" + i}
      <div id="aaa" use:myaction={{ v: id, w: "sq-ne-" + i, vertical: true }}>
        <div class="line linev"></div>
        <span class="tooltiptext ver zigzagtool">
          <div class="zigzagnodetool" style="grid-area: sw">
            <div>{@html math(b.square[0])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: se">
            <div>{@html math(b.square[1])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: nw">
            <div>{@html math(b.square[2])}</div>
          </div>
          <div class="zigzagnodetool" style="grid-area: ne">
            <div>{@html math(b.square[3])}</div>
          </div>
        </span>
      </div>
      <div {id} class="node" style="grid-area: {-(i + 1)} / {i + 1} / {-(i + 2)} / {i + 2};"></div>
    {/each}
  </div>
  <div id="ne" class="points" style="--n-points: {nePoints.length}">
    {#each nePoints.entries() as [i, b]}
      {@const id = "sq-ne-" + i}
      <div {id} class="node" style="grid-area: {-(i + 1)} / {i + 1} / {-(i + 2)} / {i + 2};"></div>
    {/each}
  </div>
</div>

<style>
  #cell {
    width: 100%;
    height: 100%;
    display: grid;
    grid-template-areas:
      "se sw"
      "ne nw";
    grid-template-columns: repeat(2, 1fr);
    grid-template-rows: repeat(2, 1fr);
    place-items: center;
    place-content: center;
    padding: 1ex;
    gap: 5px;
  }

  #sw {
    grid-area: sw;
  }

  #nw {
    grid-area: nw;
  }

  #se {
    grid-area: se;
  }

  #ne {
    grid-area: ne;
  }

  .points {
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-columns: repeat(var(--n-points), 2.25ex);
    grid-template-rows: repeat(var(--n-points), 2.25ex);
  }

  .node {
    width: var(--node-size);
    height: var(--node-size);
    border-radius: calc(var(--node-size) / 2);
    background-color: var(--color-points);
  }

  #aaa {
    position: absolute;
    width: fit-content;
    height: fit-content;
    --margin-hover: 0.7rem;
    padding: var(--margin-hover);

    & .tooltiptext {
      visibility: hidden;
      background-color: black;
      color: #fff;
      text-align: center;
      border-radius: 6px;
      padding: 5px;
      position: absolute;
      z-index: 1;

      /* Fade in tooltip - takes 1 second to go from 0% to 100% opac: */
      opacity: 0;
      transition: opacity 0.5s;
    }

    & .tooltiptext.hor {
      bottom: 100%;
      left: 50%;
      transform: translate(-50%, 0);
    }

    & .tooltiptext.ver {
      left: 100%;
      top: 50%;
      transform: translate(0, -50%);
    }

    & .tooltiptext::after {
      content: " ";
      position: absolute;
      border-width: 5px;
      border-style: solid;
    }

    & .tooltiptext.hor::after {
      top: 100%;
      left: 50%;
      margin-left: -5px;
      border-color: black transparent transparent transparent;
    }

    & .tooltiptext.ver::after {
      right: 100%;
      top: 50%;
      margin-top: -5px;
      border-color: transparent black transparent transparent;
    }

    & .line {
      background-color: var(--color-points);
    }

    & .linev {
      width: 3px;
      height: 100%;
    }

    & .lineh {
      width: 100%;
      height: 3px;
    }

    &:hover .tooltiptext {
      visibility: visible;
      opacity: 1;
    }
  }

  .zigzagtool {
    display: grid;
    grid-template-areas:
      "se sw"
      "ne nw";
    gap: -3px;
    grid-template-columns: repeat(2, 1fr);
    grid-template-rows: repeat(2, 1fr);
  }

  .zigzagnodetool {
    background-color: var(--color-zigzag);
    padding: 0.18rem;
  }

  .zigzagnodetool > div {
    background-color: var(--color-points);
    padding: 0.05rem 0.3rem;
    border-radius: 3px;
  }
</style>
