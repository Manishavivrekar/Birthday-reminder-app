# CDS Control Tower — Complete Full-Stack Development Master Prompt

Act as a Senior Full-Stack Developer, Solution Architect, Oracle Database Engineer, and Enterprise UI/UX Designer.

I want you to analyze, design, and implement a complete enterprise-grade CDS Control Tower application using:

* **Frontend:** React
* **Backend:** Java Spring Boot
* **Database:** Oracle Database
* **API Communication:** REST APIs

The application is a Credit Decisioning System dashboard for business and operations teams to monitor posting requests, transaction statuses, customer accounts, disposition outcomes, and account information.

The goal is to create a **beautiful, colourful, interactive, modern, and professional enterprise fintech dashboard** with a fully functional backend connected to the Oracle database.

---

# 1. Existing Project Analysis

Before writing any code, inspect the existing project.

* Identify the current React, Java, Spring Boot, Node.js, and dependency versions.
* Understand the existing frontend and backend folder structures.
* Inspect existing React components, API services, routing, state management, and styling framework.
* Inspect the Oracle database configuration, entities, repositories, SQL queries, and existing APIs.
* Understand the current coding conventions and architecture.
* Reuse existing code, dependencies, and components wherever possible.
* Do not unnecessarily upgrade dependencies or rewrite working modules.
* Identify missing information and ask questions before assuming business logic.
* Do not overwrite or remove existing functionality without understanding its purpose.

First provide a clear implementation plan, database relationship analysis, and proposed dashboard architecture.

---

# 2. Database Tables and Schema

The application uses the following four Oracle database tables.

## A. CDS_POSTING_REQUEST

Stores posting request and transaction information.

| Column              | Data Type          | Nullable |
| ------------------- | ------------------ | -------- |
| INBOUNDMESSAGE_ID   | VARCHAR2(25 BYTE)  | NOT NULL |
| REQUEST_ID          | VARCHAR2(90 BYTE)  | NOT NULL |
| CDS_FUNDTRANSFER_ID | VARCHAR2(50 BYTE)  | YES      |
| DR_ACCOUNT_ID       | VARCHAR2(50 BYTE)  | YES      |
| CR_ACCOUNT_ID       | VARCHAR2(50 BYTE)  | YES      |
| AMOUNT              | NUMBER(21,4)       | YES      |
| CURRENCY            | VARCHAR2(10 BYTE)  | YES      |
| STATUS              | VARCHAR2(20 BYTE)  | YES      |
| DESCRIPTION         | VARCHAR2(500 BYTE) | YES      |
| RESPONSE_INBOUND_ID | VARCHAR2(25 BYTE)  | YES      |
| PAUSE               | VARCHAR2(5 BYTE)   | YES      |
| HELD_PAYLOAD        | CLOB               | YES      |
| CREATED_AT          | TIMESTAMP(6)       | NOT NULL |
| CREATED_BY          | VARCHAR2(30 BYTE)  | NOT NULL |
| CREATED_FROM        | VARCHAR2(100 BYTE) | NOT NULL |
| UPDATED_AT          | TIMESTAMP(6)       | YES      |
| UPDATED_BY          | VARCHAR2(30 BYTE)  | YES      |
| UPDATED_FROM        | VARCHAR2(100 BYTE) | YES      |

## B. CDS_ACCOUNT

Stores account information and account balances.

| Column                | Data Type          | Nullable |
| --------------------- | ------------------ | -------- |
| ACCOUNT_ID            | VARCHAR2(50 BYTE)  | NOT NULL |
| CUSTOMER_ID           | VARCHAR2(50 BYTE)  | YES      |
| CURRENCY              | VARCHAR2(10 BYTE)  | YES      |
| STATUS                | VARCHAR2(20 BYTE)  | YES      |
| SOD_BALANCE           | NUMBER(21,4)       | YES      |
| RUNNING_BALANCE       | NUMBER(21,4)       | YES      |
| WORKING_BALANCE       | NUMBER(21,4)       | YES      |
| PROJECTED_BALANCE     | NUMBER(21,4)       | YES      |
| COB_DATE              | TIMESTAMP(6)       | YES      |
| CREATED_AT            | TIMESTAMP(6)       | NOT NULL |
| CREATED_BY            | VARCHAR2(30 BYTE)  | NOT NULL |
| CREATED_FROM          | VARCHAR2(100 BYTE) | NOT NULL |
| UPDATED_AT            | TIMESTAMP(6)       | YES      |
| UPDATED_BY            | VARCHAR2(30 BYTE)  | YES      |
| UPDATED_FROM          | VARCHAR2(100 BYTE) | YES      |
| POSTING_RESTRICT_CODE | VARCHAR2(5 CHAR)   | YES      |
| POSTING_RESTRICT_DESC | VARCHAR2(500 CHAR) | YES      |
| ACCOUNT_TYPE_CODE     | VARCHAR2(500 CHAR) | YES      |

## C. CDS_CUSTOMER

Stores customer information and customer-level financial information.

| Column                | Data Type          | Nullable |
| --------------------- | ------------------ | -------- |
| CUSTOMER_ID           | VARCHAR2(50 BYTE)  | NOT NULL |
| GEMS_ID               | VARCHAR2(30 BYTE)  | YES      |
| CUSTOMER_NAME         | VARCHAR2(150 BYTE) | NOT NULL |
| DLOD_LIMIT            | NUMBER(21,4)       | YES      |
| OD_LIMIT              | NUMBER(21,4)       | YES      |
| MASTER_COMPANY        | VARCHAR2(20 BYTE)  | YES      |
| NET_POSITION          | NUMBER(21,4)       | YES      |
| CREATED_AT            | TIMESTAMP(6)       | NOT NULL |
| CREATED_BY            | VARCHAR2(30 BYTE)  | NOT NULL |
| CREATED_FROM          | VARCHAR2(100 BYTE) | NOT NULL |
| UPDATED_AT            | TIMESTAMP(6)       | YES      |
| UPDATED_BY            | VARCHAR2(30 BYTE)  | YES      |
| UPDATED_FROM          | VARCHAR2(100 BYTE) | YES      |
| POSTING_RESTRICT_CODE | VARCHAR2(5 CHAR)   | YES      |
| POSTING_RESTRICT_DESC | VARCHAR2(500 CHAR) | YES      |

## D. CDS_DISPO

Stores disposition information related to posting requests.

| Column            | Data Type          | Nullable |
| ----------------- | ------------------ | -------- |
| DISPO_ID          | VARCHAR2(50 BYTE)  | NOT NULL |
| INBOUNDMESSAGE_ID | VARCHAR2(50 BYTE)  | NOT NULL |
| DISPO_TYPE        | VARCHAR2(20 BYTE)  | NOT NULL |
| DISPO_STATUS      | VARCHAR2(20 BYTE)  | NOT NULL |
| REASON            | VARCHAR2(90 BYTE)  | YES      |
| CREATED_AT        | TIMESTAMP(6)       | NOT NULL |
| CREATED_BY        | VARCHAR2(30 BYTE)  | NOT NULL |
| CREATED_FROM      | VARCHAR2(100 BYTE) | NOT NULL |
| UPDATED_AT        | TIMESTAMP(6)       | YES      |
| UPDATED_BY        | VARCHAR2(30 BYTE)  | YES      |
| UPDATED_FROM      | VARCHAR2(100 BYTE) | YES      |

## Database Relationship Requirements

Investigate and verify the actual relationships before writing SQL.

Potential relationships to investigate:

* CDS_POSTING_REQUEST.INBOUNDMESSAGE_ID → CDS_DISPO.INBOUNDMESSAGE_ID
* CDS_POSTING_REQUEST.DR_ACCOUNT_ID → CDS_ACCOUNT.ACCOUNT_ID
* CDS_POSTING_REQUEST.CR_ACCOUNT_ID → CDS_ACCOUNT.ACCOUNT_ID
* CDS_ACCOUNT.CUSTOMER_ID → CDS_CUSTOMER.CUSTOMER_ID

Important:

* Do not assume these relationships are enforced by foreign-key constraints.
* Verify primary keys, foreign keys, and actual data relationships.
* A posting request may have separate debit and credit accounts.
* Determine whether a posting request can have multiple disposition records.
* Avoid duplicate transaction counts caused by one-to-many joins.
* Use LEFT JOIN where appropriate so missing related records do not unnecessarily exclude posting requests.
* Do not assume the business meaning of unfamiliar fields or status values.
* Do not expose HELD_PAYLOAD or sensitive customer/account data unnecessarily.
* Use Oracle-compatible SQL and safe handling of nullable values.

---

# 3. Business Requirements

Create a CDS Control Tower dashboard that provides an operational and business overview of the credit decisioning system.

The dashboard should help users answer:

* How many posting requests exist?
* How many requests are approved, held, rejected, or pending?
* What is the distribution of posting statuses?
* Which customers and accounts are associated with posting requests?
* What disposition outcomes have been recorded?
* What are the account balances and account statuses?
* Which accounts or customers have posting restrictions?
* What are the latest posting requests?
* Which records require investigation?

Only display metrics that can be accurately calculated from the available schema and business rules.

If a metric cannot be calculated, clearly identify the missing information instead of inventing a value.

---

# 4. Frontend — React

Build a beautiful, colourful, premium enterprise fintech dashboard.

The application should look like a professionally designed banking operations platform, not a basic admin template.

## 4.1 Design Requirements

Use a modern visual design with:

* Professional navigation and header.
* Clean, balanced layouts.
* Colourful KPI cards with meaningful icons.
* Beautiful gradients used selectively.
* Soft shadows and rounded cards.
* Clear typography and spacing.
* Modern charts and legends.
* Visually distinct status badges.
* Responsive layouts.
* Subtle animations and hover effects.
* Professional loading, empty, and error states.
* Consistent spacing, component sizing, and design tokens.

Use a clean light background with white cards as the default appearance.

Ensure the interface remains professional, readable, accessible, and suitable for enterprise banking users.

Use the existing styling framework if already configured. Do not introduce unnecessary libraries.

## 4.2 Theme Customization — Four Enterprise Color Themes

Implement a fully functional theme switcher in the dashboard header that allows users to select between four professionally designed themes.

### Theme 1 — Ocean Blue (Default)

* Primary: Deep navy blue.
* Accent: Bright blue.
* Background: Soft blue-gray.
* Cards: White.
* Style: Professional, clean, modern banking interface.

### Theme 2 — Emerald Green

* Primary: Deep emerald green.
* Accent: Vibrant teal.
* Background: Soft mint-gray.
* Cards: White.
* Style: Premium financial operations dashboard with a fresh, elegant appearance.

### Theme 3 — Royal Purple

* Primary: Deep royal purple.
* Accent: Vibrant violet.
* Background: Soft lavender-gray.
* Cards: White.
* Style: Modern, sophisticated enterprise fintech interface.

### Theme 4 — Sunset Coral

* Primary: Deep indigo.
* Accent: Coral and warm orange.
* Background: Soft warm-gray.
* Cards: White.
* Style: Visually rich, energetic, polished enterprise dashboard.

### Theme Switcher UI

* Add a beautiful theme selector in the dashboard header.
* Display all four themes with their names and colour-preview swatches.
* Use a dropdown, popover, or compact selection panel.
* Clearly highlight the currently selected theme.
* Apply theme changes instantly without page refresh.
* Add smooth and subtle theme transitions.
* Ensure the theme selector is responsive and accessible.

**Implement the four-theme selector described in the Theme Customization section. All themes must work across the complete application.**

### Dynamic Theme Architecture

Implement a centralized theme management system.

Suggested structure:

* themeConfig — centralized definitions for all four themes.
* ThemeProvider — manages the active theme.
* useTheme — reusable hook for accessing and changing themes.
* ThemeSwitcher — theme selection component in the header.

Use CSS variables or the existing styling framework's theme configuration.

Define semantic design tokens such as:

* primary
* primary-hover
* accent
* background
* surface
* surface-secondary
* text-primary
* text-secondary
* border
* success
* warning
* danger
* chart colors

Apply the selected theme consistently to:

* Header and navigation.
* KPI cards.
* Buttons and controls.
* Tables and pagination.
* Filters and search fields.
* Charts, legends, and tooltips.
* Modals, drawers, and dropdowns.
* Empty states and other reusable components.

Avoid hardcoding theme-specific colours inside individual React components.

### Chart Theme Adaptation

* Charts must adapt to the active theme.
* Update chart accents, legends, tooltips, grid lines, and labels.
* Keep transaction status colours semantically consistent across all themes.
* Approved remains green.
* Held or pending remains amber.
* Rejected remains red.
* Ensure sufficient contrast and accessibility.

### Theme Persistence

* Persist the selected theme using localStorage or the existing preference mechanism.
* Restore the selected theme after refresh.
* Use Ocean Blue for first-time users.
* Ensure the theme is applied consistently across all dashboard pages.

---

# 5. Dashboard Layout

Create a polished dashboard with the following sections.

## A. Header

Include:

* CDS Control Tower branding.
* Navigation menu.
* Global search.
* Theme switcher.
* Environment indicator.
* Dashboard view selector.
* Refresh button.
* User profile area if authentication exists.

Use a compact, professional header that does not consume unnecessary vertical space.

## B. KPI Cards

Create colourful cards for relevant metrics:

* Total Posting Requests.
* Approved Requests.
* Held Requests.
* Rejected Requests.
* Pending Requests.
* Total Customers.
* Total Accounts.
* Accounts with Posting Restrictions.

Each card should contain:

* Clear metric label.
* Large, readable number.
* Relevant icon.
* Appropriate colour accent.
* Optional percentage or comparison only when valid data supports it.
* Tooltip explaining the metric.

Do not invent trend percentages or historical comparisons.

## C. Posting Status Overview

Create a modern donut chart showing posting status distribution.

Requirements:

* Use actual status values returned by the backend.
* Display counts and percentages.
* Provide a colourful legend.
* Support chart tooltips.
* Allow users to click a status to filter posting requests, where practical.
* Handle zero records and unknown statuses correctly.

## D. Posting Activity

Create a time-based posting activity chart using CREATED_AT or another verified timestamp.

Include:

* Time-range filters.
* Daily or hourly aggregation where supported.
* Appropriate chart type.
* Empty state when insufficient data exists.

Do not create artificial historical trends from a single database record.

## E. Customer Overview

Display relevant customer information:

* Customer count.
* Customer name.
* Customer ID.
* Master company.
* Customer limits, where business definitions are confirmed.
* Net position, where meaningful and correctly defined.
* Posting restriction information.

Support searching, filtering, and customer details.

## F. Account Overview

Display relevant account information:

* Account ID.
* Customer name or ID.
* Account status.
* Currency.
* Account type.
* SOD balance.
* Running balance.
* Working balance.
* Projected balance.
* Posting restriction information.

Support searching and filtering by account and customer.

Clearly distinguish debit and credit account relationships.

## G. Recent Posting Requests

Create a modern, enterprise-level data table containing:

* Request ID.
* Fund Transfer ID.
* Inbound Message ID.
* Customer.
* Debit Account.
* Credit Account.
* Amount.
* Currency.
* Posting Status.
* Disposition Type.
* Disposition Status.
* Created At.

Only include columns that can be correctly retrieved from the schema.

Provide:

* Server-side pagination.
* Sorting.
* Search.
* Status filters.
* Date filters.
* Column alignment.
* Currency formatting.
* Status badges.
* Row hover effects.
* Details drawer or modal.
* Empty and error states.

## H. Disposition Summary

Display disposition information grouped by:

* DISPO_TYPE.
* DISPO_STATUS.
* REASON, where appropriate.

Include:

* Summary cards or charts.
* Counts by disposition status.
* Drill-down to related posting requests.
* Clear handling of multiple disposition records per posting request.

## I. Account Monitoring

Create a section for monitoring account conditions.

Display:

* Account status.
* Balance information.
* Posting restriction code and description.
* Customer details.
* Associated posting requests, where supported.

Do not assume an account is blocked solely because a restriction code exists. Use verified business rules.

---

# 6. Backend — Java Spring Boot

Implement a clean, maintainable Spring Boot backend using layered architecture.

Suggested package structure:

* controller
* service
* repository
* dto
* entity
* mapper
* exception
* config

Follow the existing project structure and dependency versions.

## 6.1 REST APIs

Design and implement the following APIs, adapting endpoint names and identifier semantics to the existing application.

### Dashboard APIs

GET /api/dashboard/summary

Returns:

* Total posting requests.
* Approved count.
* Held count.
* Rejected count.
* Pending count.
* Total customers.
* Total accounts.
* Restricted account count, if supported.

GET /api/dashboard/posting-status

Returns posting status counts and percentages.

GET /api/dashboard/posting-activity

Returns time-based posting counts.

GET /api/dashboard/disposition-summary

Returns disposition counts grouped by type and status.

### Posting Request APIs

GET /api/posting-requests

Returns paginated posting requests.

Support filters:

* requestId
* fundTransferId
* inboundMessageId
* customerId
* customerName
* accountId
* postingStatus
* dispositionStatus
* dateFrom
* dateTo
* sortBy
* sortDirection
* page
* size

GET /api/posting-requests/{inboundMessageId}

Returns posting request details and related account, customer, and disposition information.

### Customer APIs

GET /api/customers

Returns searchable and paginated customer information.

GET /api/customers/{customerId}

Returns customer details and related account information where supported.

### Account APIs

GET /api/accounts

Returns searchable and paginated account information.

GET /api/accounts/{accountId}

Returns account details and related customer information.

### Disposition APIs

GET /api/dispositions

Returns searchable and paginated disposition information.

Support relevant filters and sorting.

## 6.2 Backend Implementation Rules

* Use DTOs instead of exposing database entities directly.
* Use BigDecimal for monetary values.
* Use suitable Java timestamp types.
* Use Oracle-compatible SQL.
* Use server-side pagination, sorting, and filtering.
* Validate request parameters.
* Handle nullable database fields safely.
* Avoid N+1 queries.
* Avoid unnecessary joins and fetching entire tables.
* Avoid duplicate counts caused by one-to-many relationships.
* Use read-only transactions for dashboard queries where appropriate.
* Use consistent exception handling and API response structures.
* Add logging without exposing sensitive information.
* Do not implement approval, rejection, release, or other transaction-changing actions unless explicitly requested.

---

# 7. SQL Queries and Data Aggregation

Before implementing dashboard metrics:

1. Inspect the actual database records.
2. Identify available status values.
3. Confirm table relationships.
4. Confirm whether multiple dispositions can belong to one posting request.
5. Determine how debit and credit account joins should work.
6. Identify the correct source table for every metric.
7. Define each metric in plain business language.
8. Write and validate Oracle SQL queries.
9. Map query results to backend DTOs.

For each dashboard card, chart, and table, document:

* Business meaning.
* Source table.
* Source columns.
* Join conditions.
* Filters.
* Aggregation logic.
* Duplicate-counting risks.
* Null-handling rules.

Do not invent status values or assume that two similar-looking fields have the same meaning.

---

# 8. Mock Data and Limited Database Records

Currently, the database contains only one row in each table.

The dashboard must therefore support both real database mode and mock demonstration mode.

## Mock Data Requirements

* Create realistic mock data for dashboard demonstrations.
* Include multiple posting statuses.
* Include different customers and accounts.
* Include realistic disposition examples.
* Include sample transaction amounts and timestamps.
* Include enough records to demonstrate pagination, charts, filters, and search.
* Clearly label mock data as DEMO DATA.
* Never mix mock data with actual database data.
* Never insert fabricated production records into Oracle.
* Keep mock data in a separate module or mock API service.
* Make it easy to switch between mock mode and real API mode.

## Real Database Requirements

* The application must work correctly with zero, one, or multiple records.
* Display actual database values when real API mode is enabled.
* Handle missing relationships and nullable values.
* Do not create fake trends from insufficient data.
* Show appropriate empty states.
* Avoid displaying misleading metrics when data is incomplete.

---

# 9. Frontend and Backend Integration

Implement:

* Reusable API service layer.
* Axios or the existing HTTP client.
* Centralized API configuration.
* Environment-based backend URLs.
* Consistent response mapping.
* Loading states and skeletons.
* Error handling.
* Search and filter synchronization.
* Server-side pagination.
* Date-range filtering.
* Refresh functionality.
* Proper separation between mock and real API modes.

Ensure the React UI displays actual backend response values when connected to the real database.

Do not hardcode KPI numbers in production dashboard components.

---

# 10. Security and Performance

* Do not expose sensitive account or customer information unnecessarily.
* Do not return HELD_PAYLOAD unless explicitly required and authorized.
* Validate and sanitize user-provided search parameters.
* Prevent unsafe dynamic SQL construction.
* Restrict sorting to approved column names.
* Use appropriate API error responses.
* Avoid loading unnecessary database records.
* Review query performance and indexes.
* Follow the application's existing authentication and authorization mechanisms.
* Do not invent authentication requirements if the existing application already defines them.

---

# 11. Testing

Provide appropriate tests for:

### Backend

* Dashboard aggregation logic.
* SQL/repository queries.
* API responses.
* Empty database responses.
* Nullable fields.
* Multiple dispositions per posting request.
* Debit and credit account joins.
* Pagination and sorting.
* Search and filters.

### Frontend

* Dashboard rendering.
* KPI cards.
* Charts.
* Data tables.
* Empty and error states.
* Theme switching.
* Theme persistence.
* Theme consistency across pages.
* Mock mode and real API mode.
* Search, filters, and pagination.

---

# 12. Deliverables

Implement the application incrementally and provide:

1. Existing project analysis.
2. Verified database relationship diagram.
3. Dashboard UI architecture.
4. Four-theme configuration and theme switcher.
5. React components and pages.
6. Spring Boot package structure.
7. Oracle SQL queries.
8. Entities, DTOs, repositories, services, and controllers.
9. Dashboard aggregation APIs.
10. Posting request, customer, account, and disposition APIs.
11. Frontend API integration.
12. Separate mock-data implementation.
13. Error handling and validation.
14. Unit and integration tests.
15. Setup and execution instructions.
16. API documentation.
17. Database-to-dashboard field mapping document.

For every major implementation step, explain:

* What is being built.
* Why it is required.
* Which database tables are involved.
* How the backend processes the data.
* How React displays the response.
* How to test the functionality.

## Final Instructions

Do not generate the entire application as one large, unstructured code block.

Work incrementally:

**Step 1:** Analyze the existing project and database schema.

**Step 2:** Confirm relationships and define dashboard metrics.

**Step 3:** Design the colourful dashboard and four themes.

**Step 4:** Build the backend APIs and validate SQL.

**Step 5:** Build React components using mock data.

**Step 6:** Connect React to Spring Boot APIs.

**Step 7:** Test all functionality with empty, single-record, and multiple-record scenarios.

**Step 8:** Provide setup instructions and documentation.

Prioritize clean architecture, accurate data, beautiful enterprise UI, maintainable code, and a dashboard that works correctly with both the current small dataset and future production-scale data.
