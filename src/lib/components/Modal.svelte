<script lang="ts">
  import Button from "$lib/components/Button.svelte";

  let {
    showModal = $bindable(),
    onClose,
    onAbort,
    buttonLabel,
    buttonDisabled,
    header,
    children
  } = $props();

  let dialog = $state();

  async function wrappedOnClose() {
    onClose();
    dialog.close();
  }

  $effect(() => {
    if (showModal) dialog.showModal();
  });
</script>

<dialog
  bind:this={dialog}
  onclose={() => (showModal = false)}
  onclick={(e) => {
    if (e.target === dialog) {
      onAbort();
      dialog.close();
    }
  }}
>
  <div>
    {@render header?.()}
    {@render children?.()}
    <Button label={buttonLabel} disabled={buttonDisabled} onClick={wrappedOnClose} />
  </div>
</dialog>

<style>
  dialog {
    max-width: 32em;
    border-radius: 0.2em;
    border: none;
    padding: 0;
  }
  dialog::backdrop {
    background: rgba(0, 0, 0, 0.3);
  }
  dialog > div {
    padding: 1em;
    display: flex;
    flex-direction: column;
    gap: 0.8em;
  }
  dialog[open] {
    animation: zoom 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  @keyframes zoom {
    from {
      transform: scale(0.95);
    }
    to {
      transform: scale(1);
    }
  }
  dialog[open]::backdrop {
    animation: fade 0.2s ease-out;
  }
  @keyframes fade {
    from {
      opacity: 0;
    }
    to {
      opacity: 1;
    }
  }

  dialog > div > :global(button) {
    width: min-content;
    margin: 0 0 0 auto;
  }
</style>
