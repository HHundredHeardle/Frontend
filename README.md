# Hottest Hundred Heardle Frontend

## Introduction

This is the frontend for Hottest Hundred Heardle, a web app inspired by the now-defunct music guessing game Heardle, and featuring songs that have featured in Triple J's Hottest 100. Hottest Hundred Heardle is intended to run in a browser, and support both mobile and desktop use.

## Table of Contents
- [1 - Repository Organisation](#1---repository-organisation)
  - [1.1 - Repository Structure](#11---repository-structure)
    - [1.1.1 - Main](#111---main)
    - [1.1.2 - Dev](#112---dev)
    - [1.1.3 - Feature branches](#113---feature-branches)
  - [1.2 - Project Management](#12---project-management)
- [2 - Architecture](#2---architecture)
  - [2.1 - Flutter](#21---flutter)
- [3 - Features](#3---features)

## 1 - Repository Organisation

###  1.1 - Repository Structure

#### 1.1.1 - Main

The main branch contains the latest stable version of the project. Main should only be updated by pull requests from dev.

#### 1.1.2 - Dev

The dev branch contains the master developmental version of the project. Committing directly to dev should be avoided, instead feature branches should be made from dev.

#### 1.1.3 - Feature branches

Specific features should be implemented in their own branch created from dev, and merged with dev upon completion.

### 1.2 - Project Management

Project tasks will be managed using [the HHundredHeardle GitHub Projects Board](https://github.com/orgs/HHundredHeardle/projects/1/views/1). This board will coordinate tasks project-wide, including the frontend, future backend, and other potential areas. Features and fixes will be managed with this board through creating issues for the respective repositories.

## 2 - Architecture

### 2.1 - Flutter

Flutter will be used to create the client-side application. This allows access to the benefits of using dart, including type safety and aspects of functional programming. Flutter also allows for the potential of creating mobile and desktop applications in the future. 

## 3 - Features
