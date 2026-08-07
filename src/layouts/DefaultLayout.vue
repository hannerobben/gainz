<script setup lang="ts">
import AppFooterMenu from '../components/AppFooterMenu.vue';
import AppHeader from "../components/AppHeader.vue";
</script>

<template>
    <div class="full-page">
      <AppHeader></AppHeader>
        <div class="page-container custom-scrollbar">
            <div class="page-content">
                <RouterView />
            </div>
        </div>
        <AppFooterMenu />
    </div>
</template>

<style scoped>
.full-page {
    height: 100%;
    min-height: 0;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.page-container {
    height: 100%;
    min-height: 0;
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    overflow-y: auto;
    background-color: whitesmoke;

    .page-content {
        height: 100%;
        min-height: 0;
        display: flex;
        flex-direction: column;
    }
}
</style>
