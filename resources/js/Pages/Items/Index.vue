<script setup>
import FlashMessage from '@/Components/FlashMessage.vue';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    items: Array
})

</script>

<template>

    <Head title="商品一覧" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">商品一覧</h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6 text-gray-900">
                        <section class="text-gray-600 body-font">
                            <div class="container px-5 py-8 mx-auto">
                                <FlashMessage />
                                <div class="flex pl-4 my-4 lg:w-2/3 w-full mx-auto">
                                    <a class="text-indigo-500 inline-flex items-center md:mb-2 lg:mb-0">Learn More
                                        <svg fill="none" stroke="currentColor" stroke-linecap="round"
                                            stroke-linejoin="round" stroke-width="2" class="w-4 h-4 ml-2"
                                            viewBox="0 0 24 24">
                                            <path d="M5 12h14M12 5l7 7-7 7"></path>
                                        </svg>
                                    </a>
                                    <Link as="button" :href="route('items.create')" class="flex ml-auto text-white bg-indigo-500 border-0 py-2 px-6 focus:outline-none hover:bg-indigo-600 rounded">商品登録</Link>
                                </div>
                                <div class="lg:w-2/3 w-full mx-auto overflow-auto">
                                    <table class="table-auto w-full text-left whitespace-no-wrap">
                                        <thead>
                                            <tr>
                                                <th
                                                    class="px-4 py-3 title-font tracking-wider font-medium text-gray-900 text-sm bg-gray-100 rounded-tl rounded-bl">
                                                    ID</th>
                                                <th
                                                    class="px-4 py-3 title-font tracking-wider font-medium text-gray-900 text-sm bg-gray-100">
                                                    商品名</th>
                                                <th
                                                    class="px-4 py-3 title-font tracking-wider font-medium text-gray-900 text-sm bg-gray-100">
                                                    価格</th>
                                                <th
                                                    class="px-4 py-3 title-font tracking-wider font-medium text-gray-900 text-sm bg-gray-100">
                                                    ステータス</th>
                                                
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="item in items" :key="item.id">
                                                <td class="px-4 py-3 border-b-2 border-gray-200"><Link class="text-blue-400" :href="route('items.show', { item: item.id })">{{ item.id }}</Link></td>
                                                <td class="px-4 py-3 border-b-2 border-gray-200">{{ item.name }}</td>
                                                <td class="px-4 py-3 border-b-2 border-gray-200">{{ item.price }}</td>
                                                <td class="px-4 py-3 border-b-2 border-gray-200 text-lg text-gray-900">
                                                    <span v-if="item.is_selling=== 1">販売中</span>
                                                    <span v-if="item.is_selling=== 0">販売停止</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
