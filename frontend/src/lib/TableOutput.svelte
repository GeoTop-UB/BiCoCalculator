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
    if (vertical) {
      var fT = from.offsetTop;
      var tT = to.offsetTop 	 + to.offsetHeight;
      var fL = from.offsetLeft + from.offsetWidth/2;
      var tL = to.offsetLeft 	 + to.offsetWidth/2;
    } else {
      var fT = from.offsetTop + from.offsetHeight/2;
      var tT = to.offsetTop 	 + to.offsetHeight/2;
      var fL = from.offsetLeft + from.offsetWidth;
      var tL = to.offsetLeft;
    }
    
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
		// the node has been mounted in the DOM

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
  {#each Object.entries(datatab).sort(compare) as [key, value]}
    {@const dim = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
    {#if dim[0] == 0}
      <div>{dim[1]}</div>
    {/if}
    <!-- <div>{@html value.map(b => (b === "b"? "<div id='start'>" : (b === "a*abar"? "<div id='end'>" : "<div>")) + math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
    {#if type === "zigzags"}
      {@const points = value.filter(b => b.type === "point")}
      {@const starts = value.filter(b => b.type === "start")}
      {@const ends = value.filter(b => b.type === "end")}
      
      <div>
        <div class="points" style="--n-points: {Math.ceil(Math.sqrt(points.length))}">
          {#each points as b}
            <div class="node">
              {@html math(b.value.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", ""))}
            </div>
          {/each}
        </div>
        <div class="starts" style="--n-points: {starts.length}">
          {#each starts.sort(compareorder).entries() as [index, b]}
            {@const islinedel = b.type === "start" && b.del != "0"}
            {@const islinedelbar = b.type === "start" && b.delbar != "0"}
            {@const id = "start-" + b.value}
            {#if islinedel}
              <div class="line" use:myaction={{v: b.value, w: b.del, vertical: false}}></div>
            {/if}
            {#if islinedelbar}
              <div class="line" use:myaction={{v: b.value, w: b.delbar, vertical: true}}></div>
            {/if}
            <div id={id} class="node" style="grid-area: {-(index+1)} / {(index+1)} / {-(index+2)} / {index+2};">
              {@html math(b.value.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", ""))}
            </div>
          {/each}
        </div>
        <div class="ends" style="--n-points: {ends.length}">
          {#each ends.sort(compareorder).entries() as [index, b]}
            {@const id = "end-" + b.value}
            <div id={id} class="node" style="grid-area: {-(index+1)} / {(index+1)} / {-(index+2)} / {index+2};">
              {@html math(b.value.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", ""))}
            </div>
          {/each}
        </div>
      </div>
    {:else}
      <div>{@html value.map(b => "<div>" + math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div>
    {/if}
  {/each}
  <div></div>
  {#each [...Array(n).keys()] as key}
    <div>{key}</div>
  {/each}
</div>

<style>
  .line {
    position:absolute;
    width: 2px;
    /* margin-top:-1px; */
    background-color:rgb(100, 100, 100);
    border: 1px rgb(100, 100, 100) solid;
  }
  
  .node {
    padding: 0.05rem 0.2rem;
    background-color: rgb(240, 240, 240);
    border: 2px rgb(100, 100, 100) solid;
    border-radius: 4px;
  }

  .points {
    grid-area: points;
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-columns: repeat(var(--n-points), 1fr);
    grid-template-rows: repeat(var(--n-points), 1fr);
  }

  .starts {
    grid-area: starts;
  }

  .ends {
    grid-area: ends;
  }

  .starts, .ends {
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-columns: repeat(var(--n-points), 1fr);
    grid-template-rows: repeat(var(--n-points), 1fr);
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

  #output2.cohomology > div {
    border: 1px black dashed;
    padding: 10px;
    width: 100%;
    height: 100%;
    display: flex;
    /* flex-direction: column; */
    align-items: center;
    justify-content: center;
  }
  
  #output2.zigzags > div {
    border: 1px black dashed;
    padding: 10px;
    width: 100%;
    height: 100%;
    display: grid;
    place-items: center;
    place-content: center;
    grid-template-areas: 
      ".      .      ends "
      ".      starts .    "
      "points .      .    ";
  }
</style>