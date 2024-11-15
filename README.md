# Hottest Hundred Heardle Frontend

## Introduction

This is the frontend for Hottest Hundred Heardle, a web app inspired by the now-defunct music guessing game Heardle, and featuring songs that have featured in Triple J's Hottest 100. Hottest Hundred Heardle is intended to run in a browser, and support both mobile and desktop use.

## Table of Contents
* 1 - [Introduction](#introduction)
* 2 - [Repository Organisation](#repository-organisation)
  * 2.1 - [Repository Structure](#repository-structure)
    * 2.1.1 - [Main](#main)
    * 2.1.2 - [Dev](#main)
    * 2.1.3 - [Feature Branches](#feature-branches)
  * 2.2 [Project Management](#project-management)
* 3 - Architecture
  * 3.1 [Flutter](#flutter)
  * 3.2 [Vercel](#vercel)
* 4 - [Features](#features)

## Repository Organisation

###  Repository Structure

#### Main

The main branch contains the latest stable version of the project. Main should only be updated by pull requests from dev.

#### Dev

The dev branch contains the master developmental version of the project. Committing directly to dev should be avoided, instead feature branches should be made from dev.

#### Feature branches

Specific features should be implemented in their own branch created from dev, and merged with dev upon completion.

### Project Management

Project tasks will be managed using [the HHundredHeardle GitHub Projects Board](https://github.com/orgs/HHundredHeardle/projects/1/views/1). This board will coordinate tasks project-wide, including the frontend, future backend, and other potential areas. Features and fixes will be managed with this board through creating issues for the respective repositories.

## Architecture

### Flutter

Flutter will be used to create the client-side application. This allows access to the benefits of using dart, including type safety and aspects of functional programming. Flutter also allows for the potential of creating mobile and desktop applications in the future. 

### Vercel

The web app will be hosted with vercel.

## Features
