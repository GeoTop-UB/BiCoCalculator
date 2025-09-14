<script>
  import { math } from 'mathlifier';

	let { datatab, n, type } = $props();

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
  
  function compareorder(a, b){
    if (a.order > b.order) {
      return 1;
    } else if (a.order < b.order) {
      return -1;
    }
    return 0;
  }

  function adjustLine(from, to, line, vertical) {
    const remToPx = parseFloat(getComputedStyle(document.documentElement).fontSize);
    const marginRem = parseFloat(getComputedStyle(line).getPropertyValue("--margin-hover"));
    const margin = marginRem * remToPx;

    const fT = from.offsetTop  + from.offsetHeight / 2;
    const tT = to.offsetTop 	 + to.offsetHeight / 2;
    const fL = from.offsetLeft + from.offsetWidth / 2;
    const tL = to.offsetLeft 	 + to.offsetWidth / 2;

    const px = "px";
    if (vertical) {
      line.style.top    = (tT - margin) + px;
      line.style.left   = (tL - margin - 1)  + px;
      line.style.height = (fT - tT + 2 * margin) + px;
    } else {
      line.style.top    = (fT - margin - 1) + px;
      line.style.left   = (fL - margin) + px;
      line.style.width = (tL - fL + 2 * margin) + px;
    }
  }

  function myaction(node, {v, w, vertical}) {
		$effect(() => {
      adjustLine(
        document.getElementById("start-" + v), 
        document.getElementById("end-" + w),
        node,
        vertical
      );

			return () => {};
		});
	}
</script>

<div id="output2" class={type} style="--n: {n}">
  {#if type === "zigzags" || type === "squares"}
    {#each Object.entries(datatab.basis).sort(compare) as [key, value]}
      {@const dim = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
      {@const notfirstrow = dim[1] != 0}
      {@const notfirstcol = dim[0] != 0}
      {@const points = value.filter(b => b.type === "point")}
      {@const nopoints = value.filter(b => (b.type === "start" || b.type === "end"))}

      {#if dim[0] == 0}
        <div class="yidx">{dim[1]}</div>
      {/if}
      <div class={["cell", {notfirstrow}, {notfirstcol}]}>
        <div class="points tooltip" style="--n-points: {Math.ceil(Math.sqrt(points.length))}">
          <div class="node"></div>
          <div class="exp">{@html math(points.length.toString())}</div>
          <div class="tooltiptext pointstool">
            {#each points as b}
              <div class="nodetool">
                {@html math(b.value)}
              </div>
            {/each}
          </div>
        </div>
        <div class="ends" style="--n-points: {datatab.tracks[key]}">
          {#each nopoints.sort(compareorder).entries() as [index, b]}
            {@const isstart = b.type === "start"}
            {@const islinedel = isstart && b.del != "0"}
            {@const islinedelbar = isstart && b.delbar != "0"}
            {@const id = isstart? "start-" + b.value : "end-" + b.value}
            {#if islinedel}
              <div id="aaa" use:myaction={{v: b.value, w: b.del, vertical: false}}>
                <div class="line lineh"></div>
                <span class="tooltiptext hor zigzagtool" style="--n-zig: {b.zigzag.n}; --m-zig: {b.zigzag.m}">
                  {#each Object.entries(b.zigzag.z) as [zk, zv]}
                    {@const kdim = zk.substring(1, zk.length - 1).split(",").map(b => parseInt(b.trim()))}
                    <div class="zigzagnodetool" style="grid-area: {-(kdim[1]+1)} / {(kdim[0]+1)} / {-(kdim[1]+2)} / {kdim[0]+2};">
                      <div>{@html math(zv)}</div>
                    </div>
                  {/each}
                </span>
              </div>
            {/if}
            {#if islinedelbar}
              <div id="aaa" use:myaction={{v: b.value, w: b.delbar, vertical: true}}>
                <div class="line linev"></div>
                <span class="tooltiptext ver zigzagtool" style="--n-zig: {b.zigzag.n}; --m-zig: {b.zigzag.m}">
                  {#each Object.entries(b.zigzag.z) as [zk, zv]}
                    {@const kdim = zk.substring(1, zk.length - 1).split(",").map(b => parseInt(b.trim()))}
                    <div class="zigzagnodetool" style="grid-area: {-(kdim[1]+1)} / {(kdim[0]+1)} / {-(kdim[1]+2)} / {kdim[0]+2};">
                      <div>{@html math(zv)}</div>
                    </div>
                  {/each}
                </span>
              </div>
            {/if}
            <div id={id} class="node" style="grid-area: {-(b.order+1)} / {(b.order+1)} / {-(b.order+2)} / {b.order+2};"></div>
          {/each}
        </div>
      </div>
    {/each}
    <div></div>
    {#each [...Array(n).keys()] as key}
      <div class="xidx">{key}</div>
    {/each}
  {:else}
    {#each Object.entries(datatab).sort(compare) as [key, value]}
      {@const dim = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
      {@const notfirstrow = dim[1] != 0}
      {@const notfirstcol = dim[0] != 0}

      {#if dim[0] == 0}
        <div class="yidx">{dim[1]}</div>
      {/if}
      <div class={["cell", {notfirstrow}, {notfirstcol}]} >{@html value.map(b => "<div>" + math(b) + "</div>").join("")}</div>
    {/each}
    <div></div>
    {#each [...Array(n).keys()] as key}
      <div class="xidx">{key}</div>
    {/each}
  {/if}
</div>

<style>
  #aaa {
    position:absolute;
    width: fit-content;
    height: fit-content;
    --margin-hover: 0.7rem;
    padding: var(--margin-hover);
    
    & .tooltiptext {
      visibility: hidden;
      /* width: 120px; */
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
      transform: translate(-50%,0);
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
      /* box-sizing: content-box; */
      /* margin-top:-1px; */
      /* background-color:rgb(100, 100, 100); */
      /* border: 1px rgb(100, 100, 100) solid; */
      background-color:var(--color-points);
      /* border: 1px var(--color-points) solid; */
      /* margin: var(--margin-hover); */
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
    gap: -3px;
    /* place-items: center;
    place-content: center; */
    grid-template-columns: repeat(var(--n-zig), 1fr);
    grid-template-rows: repeat(var(--m-zig), 1fr);
  }

  .zigzagnodetool {
    background-color: var(--color-zigzag);
    padding: 0.18rem;
    /* border-radius: 3px; */
  }

  .zigzagnodetool > div {
    background-color: var(--color-points);
    padding: 0.05rem 0.3rem;
    border-radius: 3px;
  }
  
  .nodetool {
    padding: 0.05rem 0.2rem;
    background-color: rgb(60, 60, 60);
    /* border: 2px rgb(100, 100, 100) solid; */
    border-radius: 4px;
  }
  
  .node {
    width: var(--node-size);
    height: var(--node-size);
    border-radius: calc(var(--node-size) / 2);
    background-color: var(--color-points);
  }

  .exp {
    align-self: flex-start;
    font-size: 0.4lh;
  }

  .points > .node {
    align-self: flex-end;
  }

  .pointstool {
    grid-area: points;
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-columns: repeat(var(--n-points), 1fr);
    /* grid-template-rows: repeat(var(--n-points), 1fr); */
    gap: 0.5em;
  }

  .points {
    grid-area: points;
    display: flex;
    flex-direction: row;
    width: 2.25ex;
    height: 2.25ex;
  }

  .starts {
    grid-area: starts;
  }

  .ends {
    grid-area: ends;
  }

  /* .starts > .node, .ends > .node {

  } */

  .starts, .ends {
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-columns: repeat(var(--n-points), 2.25ex);
    grid-template-rows: repeat(var(--n-points), 2.25ex);
  }

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

  .xidx, .yidx {
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

  #output2.cohomology > .cell {
    padding: 5px 8px;
    /* width: 100%;
    height: 100%; */
    display: flex;
    /* flex-direction: column; */
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
  }

  #output2.zigzags {
    min-width: max-content;
  }
  
  #output2.zigzags > .cell {
    gap: 5px;
    width: 100%;
    height: 100%;
    display: grid;
    place-items: center;
    place-content: center;
    /* grid-template-areas: 
      ".      .    starts"
      ".      ends .     "
      "points .    .     "; */
    grid-template-areas: 
      ".      ends"
      "points .   ";
    /* width: fit-content;
    height: fit-content; */
    padding: 1ex;
    /* 
    grid-template-columns: min-content min-content min-content;
    grid-template-rows: min-content min-content min-content; */
  }
  
  [role="tooltip"] {
    display: none;
  }

  .tooltip {
    position: relative;

    & > .tooltiptext {
      visibility: hidden;
      /* width: 120px; */
      background-color: black;
      color: #fff;
      text-align: center;
      border-radius: 6px;
      padding: 5px;
      position: absolute;
      z-index: 1;
      bottom: 130%;
      left: calc(var(--node-size) / 2);
      /* margin-left: -60px; */
      transform: translate(-50%, 0);
      
      /* Fade in tooltip - takes 1 second to go from 0% to 100% opac: */
      opacity: 0;
      transition: opacity 0.5s;
    }
    & > .tooltiptext::after {
      content: " ";
      position: absolute;
      top: 100%; /* At the bottom of the tooltip */
      left: 50%;
      margin-left: -5px;
      border-width: 5px;
      border-style: solid;
      border-color: black transparent transparent transparent;
    }
    
    &:hover .tooltiptext {
      visibility: visible;
      opacity: 1;
    }
  }
</style>