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

  function adjustLine(from, to, line, vertical){
    const rootFontSize = parseFloat(getComputedStyle(document.documentElement).fontSize);
    const margin = parseFloat(getComputedStyle(line).getPropertyValue("--margin-hover")) * rootFontSize;
    var fT = from.offsetTop  + from.offsetHeight/2;
    var tT = to.offsetTop 	 + to.offsetHeight/2;
    var fL = from.offsetLeft + from.offsetWidth/2 - 1;
    var tL = to.offsetLeft 	 + to.offsetWidth/2 - 1;
    fL -= margin;
    tL -= margin;
    
    var CA   = Math.abs(tT - fT);
    var CO   = Math.abs(tL - fL);
    var H    = Math.sqrt(CA*CA + CO*CO);
    var ANG  = 180 / Math.PI * Math.acos( CA/H );

    if(tT > fT){
        var top  = (tT-fT)/2 + fT;
    }else{
        var top  = (fT-tT)/2 + tT;
    }
    if(tL > fL){
        var left = (tL-fL)/2 + fL;
    }else{
        var left = (fL-tL)/2 + tL;
    }

    if(( fT < tT && fL < tL) || ( tT < fT && tL < fL) || (fT > tT && fL > tL) || (tT > fT && tL > fL)){
      ANG *= -1;
    }
    top-= H/2;

    line.style["-webkit-transform"] = 'rotate('+ ANG +'deg)';
    line.style["-moz-transform"] = 'rotate('+ ANG +'deg)';
    line.style["-ms-transform"] = 'rotate('+ ANG +'deg)';
    line.style["-o-transform"] = 'rotate('+ ANG +'deg)';
    line.style["-transform"] = 'rotate('+ ANG +'deg)';
    line.style.top    = top +'px';
    line.style.left   = left +'px';
    line.style.height = H + 'px';
  }

  function myaction(node, {v, w, vertical}) {
		$effect(() => {
      adjustLine(
        document.getElementById("start-" + v), 
        document.getElementById("end-" + w),
        node,
        vertical
      );

			return () => {
				// teardown goes here
			};
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
      <!-- <div>{@html value.map(b => (b === "b"? "<div id='start'>" : (b === "a*abar"? "<div id='end'>" : "<div>")) + math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
      <div class={["cell", {notfirstrow}, {notfirstcol}]}>
        <div class="points tooltip" style="--n-points: {Math.ceil(Math.sqrt(points.length))}">
          <!-- {#each points as b}
            <div class="node">
              {@html math(b.value)}
            </div>
          {/each} -->
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
                <div class="line">
                  <span class="tooltiptext">Tooltip text</span>
                </div>
              </div>
            {/if}
            {#if islinedelbar}
              <div id="aaa" use:myaction={{v: b.value, w: b.delbar, vertical: true}}>
              <div class="line">
                <span class="tooltiptext">Tooltip text</span>
              </div>
              </div>
            {/if}
            <div id={id} class="node" style="grid-area: {-(b.order+1)} / {(b.order+1)} / {-(b.order+2)} / {b.order+2};">
              <!-- {@html math(b.value)} -->
              <!-- {@html math("\\bullet")} -->
            </div>
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
      <!-- <div>{@html value.map(b => (b === "b"? "<div id='start'>" : (b === "a*abar"? "<div id='end'>" : "<div>")) + math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
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
    --margin-hover: 0.9rem;
    
    & .tooltiptext {
      visibility: hidden;
      width: 120px;
      background-color: black;
      color: #fff;
      text-align: center;
      border-radius: 6px;
      padding: 5px 0;
      position: absolute;
      z-index: 1;
      bottom: 150%;
      left: 50%;
      margin-left: -60px;
      
      /* Fade in tooltip - takes 1 second to go from 0% to 100% opac: */
      opacity: 0;
      transition: opacity 0.5s;
    }
    & .tooltiptext::after {
      content: " ";
      position: absolute;
      top: 100%; /* At the bottom of the tooltip */
      left: 50%;
      margin-left: -5px;
      border-width: 5px;
      border-style: solid;
      border-color: black transparent transparent transparent;
    }

    & .line {
      /* box-sizing: content-box; */
      width: 3px;
      height: 100%;
      /* margin-top:-1px; */
      /* background-color:rgb(100, 100, 100); */
      /* border: 1px rgb(100, 100, 100) solid; */
      background-color:var(--color-points);
      /* border: 1px var(--color-points) solid; */
      margin: 0 var(--margin-hover) 0 var(--margin-hover);
    }
    
    &:hover .tooltiptext {
      visibility: visible;
      opacity: 1;
    }
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