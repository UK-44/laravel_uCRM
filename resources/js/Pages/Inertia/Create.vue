<script setup>
import { reactive } from 'vue'
import { Inertia } from '@inertiajs/inertia'

defineProps({
    errors: Object
})

const form = reactive({
    title: null,
    content: null
})

const submitFunction = () => {
    Inertia.post('/inertia', form)
    // inertiaJSの機能を使う
    // 「/inertia」に「form」のデータをPOSTする
    // ⇒ Route::post('/inertia', [InertiaTestController::class, 'store'])->name('inertia.store');
}
</script>
<template>
    <form @submit.prevent="submitFunction">
    <!-- 「.prevent」を付けることで送信してもページ再読み込みしない -->
        <div>
            <input type="text" name="title" v-model="form.title" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
            <div v-if="errors.title">{{ errors.title }}</div>
        </div>
        <div>
            <input type="text" name="content" v-model="form.content">
            <div v-if="errors.content">{{ errors.content }}</div>
        </div>
        <button>送信</button>
    </form>
</template>