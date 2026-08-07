<script setup lang="ts">
import {ref, onMounted, onUnmounted} from 'vue';
import {useRoute} from 'vue-router';
import {useUsersStore} from '../stores/users.store.ts';
import type {AppUserContract} from '../model/user.contract.ts';

const route = useRoute();
const usersStore = useUsersStore();

function initials(displayName: string): string {
    return displayName
        .split(' ')
        .map(w => w[0])
        .join('')
        .toUpperCase();
}

const dropdownOpen = ref(false);

function toggleDropdown() {
    dropdownOpen.value = !dropdownOpen.value;
}

function selectUser(user: AppUserContract) {
    usersStore.setActiveUser(user);
    dropdownOpen.value = false;
}

function handleOutsideClick(event: MouseEvent) {
    if (!(event.target as HTMLElement).closest('.user-avatar-wrapper')) {
        dropdownOpen.value = false;
    }
}

onMounted(() => document.addEventListener('click', handleOutsideClick));
onUnmounted(() => document.removeEventListener('click', handleOutsideClick));
</script>

<template>
    <div class="header">
        <span class="header-title">{{ route.meta.title }}</span>
        <div v-if="usersStore.activeUser" class="user-avatar-wrapper">
            <button class="user-avatar" @click.stop="toggleDropdown">
                {{ initials(usersStore.activeUser.display_name) }}
            </button>
            <div v-if="dropdownOpen" class="user-dropdown">
                <button
                    v-for="user in usersStore.allUsers"
                    :key="user.id"
                    class="user-dropdown-item"
                    :class="{'user-dropdown-item--active': user.id === usersStore.activeUser.id}"
                    @click="selectUser(user)"
                >
                    {{ user.display_name }}
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.header {
    position: relative;
    height: 60px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #0a0d2e;
    border-bottom: 1px solid #dee2e6;
}

.header-title {
    font-size: 0.9rem;
    font-weight: 700;
    letter-spacing: 0.08em;
    text-transform: uppercase;
}

.user-avatar-wrapper {
    position: absolute;
    right: 16px;
    top: 50%;
    transform: translateY(-50%);
}

.user-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: #0a0d2e;
    color: #ffffff;
    border: none;
    cursor: pointer;
    font-size: 0.7rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    letter-spacing: 0.05em;
}

.user-dropdown {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    background: #ffffff;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    min-width: 140px;
    overflow: hidden;
    z-index: 100;
}

.user-dropdown-item {
    width: 100%;
    padding: 10px 14px;
    border: none;
    background: none;
    cursor: pointer;
    text-align: left;
    font-size: 0.85rem;
    color: #0a0d2e;
    white-space: nowrap;

    &:hover {
        background: #f5f5f5;
    }
}

.user-dropdown-item--active {
    font-weight: 700;
    background: #f0f1f8;
}
</style>
