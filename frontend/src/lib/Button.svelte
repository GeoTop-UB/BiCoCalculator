<script>
  let { label, onClick, disabled = false, slim = false } = $props();

  function wrappedOnClick() {
    if (!disabled) {
      onClick();
    }
  }
</script>

<button class={[{ disabled }, { slim }]} onclick={wrappedOnClick}>
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

  .slim {
    padding: 3px 8px;
    font-size: medium;
  }
</style>
