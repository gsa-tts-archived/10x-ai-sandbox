<script lang="ts">
	import { getContext, createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher();
	$: dispatch('change', open);

	import { slide } from 'svelte/transition';
	import { quintOut } from 'svelte/easing';

	import ChevronUp from '../icons/ChevronUp.svelte';
	import ChevronDown from '../icons/ChevronDown.svelte';

	export let open = false;
	export let className = '';
	export let buttonClassName =
		'w-fit text-gray-600 hover:text-gray-700 dark:hover:text-gray-300 transition';
	export let title = null;

	export let grow = false;

	export let disabled = false;
	export let hide = false;
</script>

<div class={className}>
	{#if title !== null}
		<!-- svelte-ignore a11y-no-static-element-interactions -->
		<!-- svelte-ignore a11y-click-events-have-key-events -->
		<div
			class="{buttonClassName} cursor-pointer"
			on:pointerup={() => {
				if (!disabled) {
					open = !open;
				}
			}}
		>
			<div class=" w-full font-medium flex items-center justify-between gap-2">
				<div class="">
					{title}
				</div>

				<div>
					{#if open}
						<ChevronUp strokeWidth="3.5" className="size-3.5" />
					{:else}
						<ChevronDown strokeWidth="3.5" className="size-3.5" />
					{/if}
				</div>
			</div>
		</div>
	{:else}
		<!-- svelte-ignore a11y-no-static-element-interactions -->
		<!-- svelte-ignore a11y-click-events-have-key-events -->
		<div
			class="{buttonClassName} cursor-pointer"
			on:pointerup={() => {
				if (!disabled) {
					open = !open;
				}
			}}
		>
			<div>
				<slot />

				{#if grow}
					{#if open && !hide}
						<div
							transition:slide={{ duration: 300, easing: quintOut, axis: 'y' }}
							on:pointerup={(e) => {
								e.stopPropagation();
							}}
						>
							<slot name="content" />
						</div>
					{/if}
				{/if}
			</div>
		</div>
	{/if}

	{#if !grow}
		{#if open && !hide}
			<div transition:slide={{ duration: 300, easing: quintOut, axis: 'y' }}>
				<slot name="content" />
			</div>
		{/if}
	{/if}
</div>
