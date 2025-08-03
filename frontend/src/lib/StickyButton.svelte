<script>
  let { label, onClick, active } = $props();

  function wrappedOnClick() {
    onClick();
    active = !active;
  }
</script>

<button class:active onclick={wrappedOnClick}>
  {label}
</button>

<style>
  button {
    background-color: rgb(255, 210, 255);
    border: 1px solid transparent;
  }

  button:hover {
    border: 1px rgb(180, 30, 180) solid;
  }

  .active {
    border: 1px solid transparent;
    background-color: rgb(180, 30, 180);
    color: white;
  }

  .active:hover {
    border: 1px solid transparent;
    background-color: rgb(180, 30, 180);
  }
</style>
