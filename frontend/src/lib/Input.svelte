<script>
  import { math } from 'mathlifier';
  import KT from '../assets/KT.json'

  let { data = $bindable() } = $props();

  // const apiUrl = "http://127.0.0.1:5001/";
  // const response = await fetch(apiUrl);
  // KT = await response.json();
  data = {
    "n": KT.n,
    "m": KT.m,
    "cohomology_aeppli": KT.cohomology.aeppli,
    "cohomology_bottchern": KT.cohomology.bottchern,
    "cohomology_delbar": KT.cohomology.delbar,
    "cohomology_dell": KT.cohomology.dell,
    "cohomology_reduced_aeppli": KT.cohomology.reduced_aeppli,
    "cohomology_reduced_bottchern": KT.cohomology.reduced_bottchern,
    "zigzags": KT.zigzags,
    "squares": KT.squares
  };
</script>

<div id="input">
  <p>Kodaira-Thurston manifold</p>
</div>

<style>
  #input {
    width: 40%;
    border-right: 1px black solid;
  }
</style>