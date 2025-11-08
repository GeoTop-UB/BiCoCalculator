<script lang="ts">
  import type { Snippet } from "svelte";

  interface Props {
    label?: string;
    onClick?: () => void;
    active?: boolean;
    disabled?: boolean;
    slim?: boolean;
    micro?: boolean;
    children?: Snippet;
  }
  let {
    label,
    onClick,
    active = $bindable(false),
    disabled = false,
    slim = false,
    micro = false,
    children
  }: Props = $props();

  function wrappedOnClick() {
    if (!disabled && !active && onClick != undefined) {
      onClick();
    }
  }
</script>

<button class={[{ active }, { disabled }, { slim }, { micro }]} onclick={wrappedOnClick}>
  {#if children}
    {@render children()}
  {/if}
  {#if label != undefined}
    {label}
  {/if}
</button>

<style>
  button {
    font-size: 1em;
    font-weight: 500;
    font-family: inherit;
    padding: 0.6em 1.2em;
    cursor: pointer;
    background-color: var(--color-accent-light);
    border: 1px solid transparent;
    border-radius: 4px;
    transition: border-color 0.25s;
  }

  button:hover {
    border: 1px var(--color-accent-strong) solid;
  }

  button:active {
    border: 1px solid transparent;
    background-color: var(--color-accent-strong);
    color: var(--color-accent-strong-font);
  }

  /* button:focus,
  button:focus-visible {
    outline: 4px auto -webkit-focus-ring-color;
  } */

  button:focus:not(:focus-visible) {
    outline: none;
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

  .disabled,
  .disabled:hover,
  .disabled:active {
    border: 1px solid transparent;
    background-color: var(--color-disabled);
    color: var(--color-disabled-font);
    cursor: auto;
  }

  .slim {
    padding: 3px 8px;
    font-size: medium;
  }

  .micro {
    height: fit-content;
    padding: 0 5px;
    font-size: medium;
  }
</style>
