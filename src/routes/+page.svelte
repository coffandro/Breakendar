<script lang="ts">
	import { GetMonth, Month } from "$lib/calendar";
	import Calendar from "$lib/components/calendar/calendar.svelte";
	import MonthWheel from "$lib/components/month-wheel.svelte";

	let date: Date = new Date();

	let month: Month = $state(GetMonth(date.getMonth()));
	let currentMonth = month;
</script>

<svelte:head>
	<title>Breakender</title>
	<meta name="description" content="My break calender" />
</svelte:head>

<div class="flex flex-col h-screen">
	<!-- Month wheel -->
	<MonthWheel
		bind:month={month}
		{currentMonth}
	/>

	<div class="flex flex-col grow">
		<Calendar
			{month}
		/>
	</div>
</div>