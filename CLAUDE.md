# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A browser-based DB performance dashboard (`db-performance-dashboard/`) for a sales management team. Users upload two CMS raw Excel files (DB count `.xlsx` and contract count `.xls`), and the dashboard auto-generates KPI cards, charts, and sortable tables — all client-side with no backend.

## Architecture

Single-file web app (`index.html`) with no build step:
- **SheetJS (xlsx)** via CDN for Excel parsing (.xlsx/.xls)
- **Chart.js** via CDN for visualizations
- All data processing happens in-browser (no server, no external data transmission)
- Sensitive customer data (names, phone numbers) never leaves the browser

## Key Data Model

- **DB file** columns (0-indexed): G=6 customerKey, T=19 mediaCode, I=8 distributeDate, J=9 inflowDate, H=7 obName, U=20 package, AB=27 mainGift, AD=29 customerStatus
- **Contract file** columns (0-indexed): D=3 customerKey, N=13 manager, AQ=42 returnDate (cancel indicator), V=21 mainGift, W=22 undeliveredGift, X=23 gift, BT=71 brand
- Join: LEFT JOIN on customerKey (DB G col ↔ Contract D col)
- Cancel logic: contract row where AQ (returnDate) has any date value

## Running

Open `db-performance-dashboard/index.html` in a browser, or use VSCode Live Server extension (right-click → Open with Live Server).

## Design Document

`# 나의 워크샵 스킬 설계서.md` contains the full spec including tab structure, KPI definitions, test checklist, and future roadmap. `사전설문 응답 기록.md` has the original user interview. Consult these when making changes to ensure alignment with requirements.

## Language

The project owner works in Korean. UI labels are currently in English but dashboard content/data is Korean. When communicating, prefer Korean if the user writes in Korean.
