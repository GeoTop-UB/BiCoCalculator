<script>
  // import svelteLogo from './assets/svelte.svg'
  import viteLogo from '/vite.svg'
  import Counter from './lib/Counter.svelte'
  import KT from './assets/KT.json'
  import { math, display } from 'mathlifier';
  // import LeaderLine from 'leader-line';
  // import { onMount } from 'svelte';
  // import { draw } from 'svelte/transition';

	function myaction(node, {v, w}) {
		// the node has been mounted in the DOM

		$effect(() => {
      adjustLine(
        document.getElementById("start-" + v), 
        document.getElementById("end-" + w),
        node
      );

			return () => {
				// teardown goes here
			};
		});
	}

  // const apiUrl = "http://127.0.0.1:5001/";
  
  const tabs = [
    {
      "id": "cohomology_aeppli",
      "name": "Aeppli Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_bottchern",
      "name": "Bottchern Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_delbar",
      "name": "Delbar Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_dell",
      "name": "Dell Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_reduced_aeppli",
      "name": "Reduced Aeppli Cohomology",
      "type": "cohomology",
    },
    {
      "id": "cohomology_reduced_bottchern",
      "name": "Reduced Bottchern Cohomology",
      "type": "cohomology",
    },
    {
      "id": "zigzags",
      "name": "Zigzags",
      "type": "zigzags",
    },
    {// TODO
      "id": "squares",
      "name": "Squares",
      "type": "cohomology",
    }
  ];
  let data = $state();
  let number = $state();
  let n = $state();
  let tab = $state(tabs[0]["id"])
  let type = $state(tabs[0]["type"])
  // let line = $state()

	async function roll() {
    number = data["cohomology_aeppli"]["(1, 1)"];
	}

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

	async function changeTab(t) {
    tab = t.id;
    type = t.type;
    // if (type === "zigzags") {
    //   // draww()
    //   adjustLine(
    //     document.getElementById('start'), 
    //     document.getElementById('end'),
    //     // document.getElementById('line')
    //     line
    //   );
    // }
	}

  function adjustLine(from, to, line){
    console.log(from)
    console.log(to)
    console.log(line)
    var fT = from.offsetTop  + from.offsetHeight/2;
    var tT = to.offsetTop 	 + to.offsetHeight/2;
    var fL = from.offsetLeft + from.offsetWidth/2;
    var tL = to.offsetLeft 	 + to.offsetWidth/2;
    
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
    line.style.top    = top+'px';
    line.style.left   = left+'px';
    line.style.height = H + 'px';
  }

  // async function draww() {
  //   new LeaderLine(
  //     document.getElementById('start'),
  //     document.getElementById('end'),
  //     {"path": "straight"}
  //   );
  // }

  // const response = await fetch(apiUrl);
  // data = await response.json();
  data = {
    // "n": KT.n,
    // "m": KT.m,
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

  $inspect(data)
  // onMount(() => {
  //   new LeaderLine(
  //     document.getElementById('start'),
  //     document.getElementById('end'),
  //     {"path": "straight"}
  //   );
  // });
</script>

<main style="--n: {n}">
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

      <div class="card">
        <Counter />
      </div>

      
      <p>Kodaira-Thurston manifold</p>
      <button onclick={roll}>Roll the dice {@html math('A = \\pi r^2')}</button>

      {#if number !== undefined}
        <p>You rolled a {number}</p>
      {/if}
    </div>
    <div id="output">
      <div class="tab">
        {#each tabs as t}
          <button class="tablinks" onclick={() => changeTab(t)}>{t.name}</button>
        {/each}
      </div>

      <div id="output2" class={type}>
      <!-- TODO reorder list to mach expected table of cohomology -->
      {#each Object.entries(data[tab]).sort(compare) as [key, value]}
        {@const dim = key.substring(1, key.length - 1).split(",").map(b => parseInt(b.trim()))}
        {#if dim[0] == 0}
          <div>{dim[1]}</div>
        {/if}
        <!-- <div>{@html value.map(b => (b === "b"? "<div id='start'>" : (b === "a*abar"? "<div id='end'>" : "<div>")) + math(b.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
        {#if type === "zigzags"}
          <!-- <div>{@html value.map(b => "<div>" + math(b["value"].replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
          <!-- <div>{@html value.map(b => (b["type"] === "start1"? "<div id='line'></div><div id='start'>" : (b["type"] === "end"? "<div id='end'>" : "<div>")) + math(b["value"].replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", "")) + "</div>").join("")}</div> -->
          <div>
            {#each value as b}
              {@const islinedel = b.type === "start" && b.del != "0"}
              {@const islinedelbar = b.type === "start" && b.delbar != "0"}
              {@const id = b.type === "start"? "start-" + b.value : (b.type === "end"? "end-" + b.value : null)}
              {#if islinedel}
                <!-- <div id='line'bind:this={line}></div> -->
                <div class="line" use:myaction={{v: b.value, w: b.del}}></div>
              {/if}
              {#if islinedelbar}
                <div class="line" use:myaction={{v: b.value, w: b.delbar}}></div>
              {/if}
              <div id={id}>
                {@html math(b.value.replaceAll("bbar", "\\bar{b}").replaceAll("abar", "\\bar{a}").replaceAll("*", ""))}
              </div>
            {/each}
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
    </div>
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

  #output {
    width: 60%;
    margin: 1rem;
  }

  .line {
    position:absolute;
    width: 2px;
    margin-top:-1px;
    background-color:red;
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

  .tab {
    overflow: hidden;
    border: 1px solid #ccc;
    background-color: #f1f1f1;
  }

  /* Style the buttons that are used to open the tab content */
  .tab button {
    background-color: inherit;
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
  }

  /* Change background color of buttons on hover */
  .tab button:hover {
    background-color: #ddd;
  }

  /* Create an active/current tablink class */
  .tab button.active {
    background-color: #ccc;
  }
</style>
