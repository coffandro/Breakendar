<script lang="ts">
    import { GetRelativeMonth } from "$lib/calendar";
    import type { Month } from "$lib/calendar";
	import { onMount } from "svelte";

    export let month: Month, currentMonth: Month;
    let lastMonth: Month, nextMonth: Month;

    $: lastMonth = GetRelativeMonth(month, -1);
	$: nextMonth = GetRelativeMonth(month, 1);

    function ChangeMonth(newMonth: Month) {
        month = newMonth;
    }
</script>

<div class="flex justify-center items-center w-full">
  <div class="relative w-100 h-35 overflow-hidden">
    <div class="absolute -top-67.5 w-full h-100 rounded-full border border-gray-300 bg-white">

      <!-- Last Month (Left) -->
      <button
        class={
            `absolute bottom-[80px] left-[60px] text-lg cursor-pointer ${currentMonth == lastMonth ? "border-2 p-1 rounded-lg" : ""}`
        }
        onclick={() => ChangeMonth(lastMonth)}
        type="button"
      >
        {lastMonth}
      </button>

      <!-- Current Month (Bottom Center) -->
      <div
        class={
            `absolute bottom-[40px] left-1/2 -translate-x-1/2 font-bold text-2xl ${currentMonth == month ? "border-2 p-1 rounded-lg" : ""}`
        }
      >
        {month}
      </div>

      <!-- Next Month (Right) -->
      <button
        class={
            `absolute bottom-[80px] right-[60px] text-lg cursor-pointer ${currentMonth == nextMonth ? "border-2 p-1 rounded-lg" : ""}`
        }
        onclick={() => ChangeMonth(nextMonth)}
        type="button"
      >
        {nextMonth}
      </button>
    </div>
  </div>
</div>