<script>
  let { label, onClick, active, disabled } = $props();

  function wrappedOnClick() {
    if (!disabled && !active) {
      onClick();
      active = true;
    }
  }
</script>

<button class={[{active}, {disabled}]} onclick={wrappedOnClick}>
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

  .disabled {
    border: 1px solid transparent;
    background-color: rgb(220, 220, 220);
    color: rgb(85, 85, 85);
    cursor: auto;
  }

  .disabled:hover {
    border: 1px solid transparent;
    background-color: rgb(220, 220, 220);
    color: rgb(85, 85, 85);
    cursor: auto;
  }
</style>
