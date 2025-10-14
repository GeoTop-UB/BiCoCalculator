<script>
  let { label, onClick, active = $bindable(), disabled = false } = $props();

  function wrappedOnClick() {
    if (!disabled && !active) {
      onClick();
      active = true;
    }
  }
</script>

<button class={[{ active }, { disabled }]} onclick={wrappedOnClick}>
  {label}
</button>

<style>
  button {
    background-color: var(--color-accent-light);
    border: 1px solid transparent;
  }

  button:hover {
    border: 1px var(--color-accent-strong) solid;
  }

  button:active {
    border: 1px solid transparent;
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  .active {
    border: 1px solid transparent;
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  .active:hover {
    border: 1px solid transparent;
    background-color: var(--color-accent-strong);
  }

  .disabled {
    border: 1px solid transparent;
    background-color: var(--color-disabled);
    color: var(--color-disabled-font);
    cursor: auto;
  }

  .disabled:hover {
    border: 1px solid transparent;
    background-color: var(--color-disabled);
    color: var(--color-disabled-font);
    cursor: auto;
  }
</style>
