# Gluon — Before & After Examples

Real examples showing the difference between sloppy and clean AI output.

---

## Example 1: Answering a Question

### Before (Slop)
> Great question! Let me help you with that. The `useEffect` hook in React is a powerful tool that allows you to perform side effects in your functional components. It's worth noting that in React 19, there have been some changes to how effects work. To understand this fully, you need to know that effects run after the render cycle completes, which means...
>
> In summary, you should use `useEffect` for subscriptions and cleanup, but for data fetching, you should consider using Server Components or the `use` hook instead.
>
> Let me know if you need any further clarification!

### After (Clean)
> For data fetching, use Server Components or the `use` hook — not `useEffect`. Reserve `useEffect` for subscriptions and browser-only side effects (event listeners, timers).

**Token savings**: ~85%

---

## Example 2: Implementing a Feature

### Before (Slop)
> Sure! I'll go ahead and implement the user profile page for you. First, let me explain my approach. I'm going to create a new component that fetches user data from the API and displays it in a card layout. I'll use React Query for data fetching since it provides caching and automatic revalidation. Let me also add some nice loading and error states to make it production-ready.
>
> Here's what I'll do:
> 1. Create a new UserProfile component
> 2. Set up the React Query hook
> 3. Add the card layout with Tailwind
> 4. Handle loading and error states
> 5. Add the route to the router
>
> Let me start by creating the component...

### After (Clean)
> Creating the profile page at `src/app/profile/page.tsx` — Server Component that fetches user data and renders a card.
>
> [immediately writes the code]

**Token savings**: ~70%

---

## Example 3: Code Comments

### Before (Slop)
```typescript
// Import the necessary dependencies for our user service
import { db } from '../lib/db';
import { User } from '../types';

// Define the UserService class that handles user operations
export class UserService {
  // Method to get a user by their ID from the database
  async getUserById(id: string): Promise<User | null> {
    // Query the database for the user with the matching ID
    const user = await db.query.users.findFirst({
      // Filter by the provided ID
      where: (users, { eq }) => eq(users.id, id),
    });
    // Return the found user or null if not found
    return user ?? null;
  }

  // Method to create a new user in the database
  async createUser(data: NewUser): Promise<User> {
    // Insert the new user data into the users table
    const [user] = await db.insert(users).values(data).returning();
    // Return the newly created user
    return user;
  }
}
```

### After (Clean)
```typescript
import { db } from '../lib/db';
import { User } from '../types';

export class UserService {
  async getUserById(id: string): Promise<User | null> {
    const user = await db.query.users.findFirst({
      where: (users, { eq }) => eq(users.id, id),
    });
    return user ?? null;
  }

  async createUser(data: NewUser): Promise<User> {
    const [user] = await db.insert(users).values(data).returning();
    return user;
  }
}
```

**Line reduction**: 24 → 14 (42% less code, same functionality, easier to read)

---

## Example 4: Error Handling

### Before (Slop)
```typescript
async function getUser(id: string) {
  try {
    if (!id) {
      throw new Error('ID is required');
    }
    if (typeof id !== 'string') {
      throw new Error('ID must be a string');
    }
    const user = await db.users.findUnique({ where: { id } });
    if (user === undefined) {
      return null;
    }
    if (user === null) {
      return null;
    }
    return user;
  } catch (error) {
    console.error('An error occurred while fetching user:', error);
    throw error;
  }
}
```

### After (Clean)
```typescript
async function getUser(id: string) {
  return db.users.findUnique({ where: { id } });
}
```

**Eliminated**: Redundant type check (TypeScript already enforces it), impossible undefined check (Prisma returns null not undefined), pointless try/catch (just re-throws), and unnecessary null coalescing.

---

## Example 5: Over-Engineering

### Before (Slop)
```typescript
// config/feature-flags.ts
interface FeatureFlagConfig {
  name: string;
  enabled: boolean;
  description: string;
  createdAt: Date;
  updatedAt: Date;
  category: string;
  rolloutPercentage: number;
  targetUsers: string[];
  metadata: Record<string, unknown>;
}

class FeatureFlagManager {
  private flags: Map<string, FeatureFlagConfig> = new Map();

  registerFlag(config: FeatureFlagConfig): void {
    this.flags.set(config.name, config);
  }

  isEnabled(name: string): boolean {
    return this.flags.get(name)?.enabled ?? false;
  }
}

const manager = new FeatureFlagManager();
manager.registerFlag({
  name: 'dark_mode',
  enabled: true,
  description: 'Enable dark mode',
  createdAt: new Date(),
  updatedAt: new Date(),
  category: 'ui',
  rolloutPercentage: 100,
  targetUsers: [],
  metadata: {},
});

export const isDarkMode = manager.isEnabled('dark_mode');
```

### After (Clean)
```typescript
export const FEATURES = {
  darkMode: true,
} as const;
```

**When to upgrade**: When you actually need rollout percentages, user targeting, or remote flag management — use PostHog or LaunchDarkly. Don't build a framework for a boolean.
