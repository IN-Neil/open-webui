<script lang="ts">
	import { toast } from 'svelte-sonner';

	import { tick, getContext, onMount, createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();
	const i18n = getContext('i18n');

	import { settings } from '$lib/stores';
	import { copyToClipboard } from '$lib/utils';

	import MultiResponseMessages from './MultiResponseMessages.svelte';
	import ResponseMessage from './ResponseMessage.svelte';
	import UserMessage from './UserMessage.svelte';

	export let chatId;
	export let selectedModels = [];
	export let idx = 0;

	export let history;
	export let messageId;

	export let user;

	export let setInputText: Function = () => {};
	export let gotoMessage;
	export let showPreviousMessage;
	export let showNextMessage;
	export let updateChat;

	export let editMessage;
	export let saveMessage;
	export let deleteMessage;
	export let rateMessage;
	export let actionMessage;
	export let submitMessage;

	export let regenerateResponse;
	export let continueResponse;
	export let mergeResponses;

	export let addMessages;
	export let prepareRollingStart: Function = () => {};
	export let triggerScroll;
	export let readOnly = false;
	export let editCodeBlock = true;
	export let topPadding = false;
</script>

<div
	role="listitem"
	class="flex flex-col justify-between px-5 mb-3 w-full {($settings?.widescreenMode ?? null)
		? 'max-w-full'
		: 'max-w-5xl'} mx-auto rounded-lg group"
>
	{#if history.rollingStartId === messageId}
		<!-- Rolling Start Indicator -->
		<div class="flex items-center justify-between gap-2 mb-2 px-2 py-1.5 bg-blue-50 dark:bg-blue-900/30 border border-blue-200 dark:border-blue-800 rounded-lg text-sm">
			<div class="flex items-center gap-2">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-blue-500">
					<path stroke-linecap="round" stroke-linejoin="round" d="M3 4.5h14.25M3 9h9.75M3 13.5h5.25m5.25 0H21m-3-3l3 3m0 0l-3 3" />
				</svg>
				<span class="text-blue-700 dark:text-blue-300 font-medium">Rolling Start</span>
				<span class="text-blue-500 dark:text-blue-400 text-xs">— Context begins here</span>
			</div>
			<button
				class="text-xs text-gray-500 hover:text-red-500 dark:text-gray-400 dark:hover:text-red-400 transition"
				on:click={() => {
					dispatch('clearRollingStart');
				}}
			>
				Clear
			</button>
		</div>
	{/if}
	{#if history.messages[messageId]}
		{#if history.messages[messageId].role === 'user'}
			<UserMessage
				{user}
				{chatId}
				{history}
				{messageId}
				isFirstMessage={idx === 0}
				siblings={history.messages[messageId].parentId !== null
					? (history.messages[history.messages[messageId].parentId]?.childrenIds ?? [])
					: (Object.values(history.messages)
							.filter((message) => message.parentId === null)
							.map((message) => message.id) ?? [])}
				{gotoMessage}
				{showPreviousMessage}
				{showNextMessage}
				{editMessage}
				{deleteMessage}
				{prepareRollingStart}
				{readOnly}
				{editCodeBlock}
				{topPadding}
			/>
		{:else if (history.messages[history.messages[messageId].parentId]?.models?.length ?? 1) === 1}
			<ResponseMessage
				{chatId}
				{history}
				{messageId}
				{selectedModels}
				isLastMessage={messageId === history.currentId}
				siblings={history.messages[history.messages[messageId].parentId]?.childrenIds ?? []}
				{setInputText}
				{gotoMessage}
				{showPreviousMessage}
				{showNextMessage}
				{updateChat}
				{editMessage}
				{saveMessage}
				{rateMessage}
				{actionMessage}
				{submitMessage}
				{deleteMessage}
				{continueResponse}
				{regenerateResponse}
				{addMessages}
				{prepareRollingStart}
				{readOnly}
				{editCodeBlock}
				{topPadding}
			/>
		{:else}
			<MultiResponseMessages
				bind:history
				{chatId}
				{messageId}
				{selectedModels}
				isLastMessage={messageId === history?.currentId}
				{setInputText}
				{updateChat}
				{editMessage}
				{saveMessage}
				{rateMessage}
				{actionMessage}
				{submitMessage}
				{deleteMessage}
				{continueResponse}
				{regenerateResponse}
				{mergeResponses}
				{triggerScroll}
				{addMessages}
				{readOnly}
				{editCodeBlock}
				{topPadding}
			/>
		{/if}
	{/if}
</div>
