<script lang="ts">
  import { GetDays, Month, Weekday } from "$lib/calendar";

  export let month: Month;
</script>

<div class="flex flex-col grow">
  <!-- Weekday headers -->
  <div class="flex w-full border-b">
    {#each Object.values(Weekday) as weekday}
      <span class="grow text-center py-2 font-medium">{weekday.substring(0,3).toUpperCase()}</span>
    {/each}
  </div>

  <!-- Calendar grid -->
  <div class="grid grid-cols-7 auto-rows-fr grow border-b border-r">
    {#each GetDays(month, 2026) as day}
      <span
        class="flex items-center justify-end p-2 text-sm border-l border-t h-full
               {day.enabled ? 'text-gray-600' : 'text-gray-300 bg-white bg-[url(\"data:image/svg+xml,%3Csvg width=\'40\' height=\'40\' viewBox=\'0 0 40 40\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'%23fdf9ff\' fill-opacity=\'1\' fill-rule=\'evenodd\'%3E%3Cpath d=\'M0 40L40 0H20L0 20M40 40V20L20 40\'/%3E%3C/g%3E%3C/svg%3E\")] cursor-not-allowed'}"
      >
        {day.name}
      </span>
    {/each}
  </div>
</div>
