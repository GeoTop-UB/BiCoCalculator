<script lang="ts">
  import type { Snippet } from "svelte";

  interface Props {
    value: any,
    onchange: () => void;
    disabled?: boolean;
    children?: Snippet;
  }
  let {
    value = $bindable(),
    onchange,
    disabled = false,
    children
  }: Props = $props();
</script>

<select
  bind:value
  {onchange}
  {disabled}
>
  {#if children}
    {@render children()}
  {/if}
</select>

<style>
  
</style>
