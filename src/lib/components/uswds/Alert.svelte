<script lang="ts">
	import '@uswds/uswds/css/uswds.css';

	// USWDS official variants
	export let type: 'info' | 'warning' | 'success' | 'error' | 'emergency';
	export let heading: string = '';
	export let slim: boolean = false;
	export let icon: boolean = true;

	// Custom variants (not part of USWDS)
	export let border: boolean = true;

	let variations = '';
	if (slim) variations += 'usa-alert--slim';
	if (!icon) variations += 'usa-alert--no-icon';
</script>

<div class="usa-alert usa-alert--{type} {variations} {border ? '' : 'noborder'}">
	<div class="usa-alert__body">
		{#if heading}<h4 class="usa-alert__heading">{heading}</h4>{/if}
		<p class="usa-alert__text">
			<slot />
		</p>
	</div>
</div>

<style lang="postcss">
	.noborder {
		border-left: none;
	}
</style>
