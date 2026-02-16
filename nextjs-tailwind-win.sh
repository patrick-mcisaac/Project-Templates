set -e #exit on any error

echo "what is your project name?"
read Project_Name

echo "what is your repo's SSH?"
read Repo_Name


cd ~/workspace

if [ -d ~/workspace/"${Project_Name}-client" ]
then 
    echo "${Project_Name}-client already exists"
    exit 1
fi

# Next Setup
npx create-next-app@latest "${Project_Name}-client" \
    --typescript \
    --tailwind \
    --eslint \
    --app \
    --src-dir \
    --import-alias "@/*" \
    --no-git

cd "${Project_Name}-client"

if [ -d .git ]
then
    rm -rf .git
fi

# Preferred Plugins 
npm install -D \
    prettier \
    prettier-plugin-tailwindcss \
    eslint-config-prettier

npm install @tanstack/react-query @tanstack/react-query-devtools

# Font Awesome Core packages
npm install @fortawesome/fontawesome-svg-core @fortawesome/react-fontawesome

# Icon packages 
npm install @fortawesome/free-solid-svg-icons
npm install @fortawesome/free-regular-svg-icons
npm install @fortawesome/free-brands-svg-icons

# Remove Default Files
rm -rf public/*

rm -rf src/app/favicon.ico

# Override Home Page
cat > src/app/page.tsx << 'EOF'
export default function Home() {
    return <div></div>
}
EOF

# Make Directories

mkdir -p "src/app/(auth)" \
    "src/app/(auth)/login" \
    "src/app/(auth)/register" \
    src/components \
    src/components/nav \
    src/components/forms \
    src/types \
    src/data \
    src/hooks \
    src/utility \
    public/images \
    public/svg

# Setup NavBar
cat > src/components/nav/NavBar.tsx << 'EOF'
"use client"
import { useState } from "react"
import HamburgerToggle from "./HamburgerToggle"
import NavItems from "./NavItems"

export default function NavBar() {
    const [isVisible, setIsVisible] = useState(false)
    return (
        <nav className="absolute w-screen">
            <NavItems
                ulClass="md:flex h-25 gap-10 pl-10 justify-start text-5xl flex-row hidden"
                linkClass=""
                setIsVisible={setIsVisible}
            />

            {/* Mobile Nav */}
            {isVisible ?
                <NavItems
                    ulClass={`md:hidden h-fit w-100 flex-col`}
                    linkClass="flex h-15 w-full  items-center justify-center"
                    setIsVisible={setIsVisible}
                />
            :   <HamburgerToggle
                    className={`text-4xl md:hidden`}
                    setIsVisible={setIsVisible}
                />
            }
        </nav>
    )
}

EOF

cat > src/components/nav/NavItems.tsx << 'EOF'
"use client"
import { faX } from "@fortawesome/free-solid-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import Link from "next/link"
import { Dispatch, SetStateAction } from "react"

type NavItemProps = {
    ulClass: string
    linkClass: string
    setIsVisible: Dispatch<SetStateAction<boolean>>
}

export default function NavItems({
    ulClass,
    linkClass,
    setIsVisible
}: NavItemProps) {
    return (
        <ul className={`${ulClass} nav tracking-widest md:flex-row`}>
            {localStorage.getItem("Project_Name") ?
                <>
                    <Link
                        onClick={() => setIsVisible(false)}
                        className={`${linkClass}`}
                        href={"/"}
                    >
                        <li>Home</li>
                    </Link>
                    <Link
                        className={`${linkClass} md:mr-10 md:ml-auto`}
                        href={"/login"}
                        onClick={() => {
                            localStorage.removeItem("Project_Name")
                            setIsVisible(false)
                        }}
                    >
                        <li>Logout</li>
                    </Link>
                    {/* Use same height as Link */}
                    <li
                        onClick={() => setIsVisible(false)}
                        className="flex h-15 w-screen items-center justify-center hover:cursor-pointer md:hidden"
                    >
                        <FontAwesomeIcon icon={faX} />
                    </li>
                </>
            :   <Link
                    onClick={() => setIsVisible(false)}
                    className={`${linkClass}`}
                    href={"/login"}
                >
                    <li>Login</li>
                </Link>
            }
        </ul>
    )
}

EOF

# Mobile Hamburger Menu

cat > src/components/nav/HamburgerToggle.tsx << 'EOF'
"use client"
import { faBars } from "@fortawesome/free-solid-svg-icons"
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome"
import { Dispatch, SetStateAction } from "react"

type NavItemProps = {
    className: string
    setIsVisible: Dispatch<SetStateAction<boolean>>
}

export default function HamburgerToggle({
    className,
    setIsVisible
}: NavItemProps) {
    return (
        <div className={`${className} mr-3 flex h-15 items-center justify-end`}>
            <button onClick={() => setIsVisible(true)}>
                <FontAwesomeIcon icon={faBars} />
            </button>
        </div>
    )
}
EOF

# Setup Form Components
cat > src/components/forms/Button.tsx << 'EOF'
import React from "react"
type ButtonProps = {
    className: string
    onClick: React.MouseEventHandler<HTMLButtonElement>
}
export default function Button({ className, onClick }: ButtonProps) {
    return (
        <button
            className={`${className} button racking-wider cursor-pointer tracking-widest transition hover:scale-110 md:w-50 md:text-xl md:font-semibold`}
            onClick={onClick}
        >
            Login
        </button>
    )
}
EOF

cat > src/components/forms/Input.tsx << 'EOF'
import React from "react"
type InputProps = {
    type: string
    className: string
    label: string
    id: string
    onChange: React.ChangeEventHandler<HTMLInputElement>
    value: string
}
export default function Input({
    type,
    className,
    label,
    id,
    onChange,
    value
}: InputProps) {
    return (
        <fieldset className="flex flex-col gap-2 tracking-widest">
            <label htmlFor={id} className="pl-2">
                {label}
            </label>
            <input
                id={id}
                type={type}
                className={`${className} bg-midground rounded-2xl p-1 pl-3 text-xl md:w-100`}
                placeholder={label}
                onChange={onChange}
                value={value}
            />
        </fieldset>
    )
}
EOF

# Setup Login
cat > "src/app/(auth)/login/page.tsx" << 'EOF'
"use client"
import Button from "@/components/forms/Button"
import Input from "@/components/forms/Input"

export default function Login() {
    return (
        <form className="-mt-10 flex h-screen flex-col items-center justify-center gap-15">
            <Input
                label="username"
                id="username"
                value=""
                onChange={() => {}}
                type="text"
                className=""
            />

            <Input
                label="password"
                id="password"
                value=""
                onChange={() => {}}
                type="password"
                className=""
            />

            <Button onClick={() => {}} className="" />
        </form>
    )
}
EOF

# Setup Register

# Setup Auth

# Setup TanStackQuery
cat > src/app/providers.tsx << 'EOF'
"use client"
import React, { useState } from "react"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { ReactQueryDevtools } from "@tanstack/react-query-devtools"

export default function Providers({ children }: { children: React.ReactNode }) {
    const [queryClient] = useState(() => new QueryClient())
    return (
        <QueryClientProvider client={queryClient}>
            {children}
            {process.env.NODE_ENV === "development" && (
                <ReactQueryDevtools initialIsOpen={false} />
            )}
        </QueryClientProvider>
    )
}
EOF

# Layout

cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from "next"
import { Geist, Geist_Mono } from "next/font/google"
import "./globals.css"
import Providers from "./providers"
import NavBar from "@/components/nav/NavBar"

const geistSans = Geist({
    variable: "--font-geist-sans",
    subsets: ["latin"]
})

const geistMono = Geist_Mono({
    variable: "--font-geist-mono",
    subsets: ["latin"]
})

export const metadata: Metadata = {
    title: "Create Next App",
    description: "Generated by create next app"
}

export default function RootLayout({
    children
}: Readonly<{
    children: React.ReactNode
}>) {
    return (
        <html lang="en">
            <body
                className={`${geistSans.variable} ${geistMono.variable} flex min-h-screen flex-col justify-start antialiased`}
            >
                <NavBar />
                <Providers>{children}</Providers>
            </body>
        </html>
    )
}

EOF


# CSS
cat > src/app/globals.css << 'EOF'
@import "tailwindcss";

:root {
    --background: #ffffff;
    --foreground: #171717;
    --midground: #3a3939;
}

@theme inline {
    --color-background: var(--background);
    --color-foreground: var(--foreground);
    --color-midground: var(--midground);
    --font-sans: var(--font-geist-sans);
    --font-mono: var(--font-geist-mono);
}

@media (prefers-color-scheme: dark) {
    :root {
        --background: #0a0a0a;
        --foreground: #ededed;
        --midground: #242424;
    }
}

@layer components {
    .nav {
        display: flex;
        align-items: center;
        font-size: 1.8rem;
        font-weight: bold;
        width: 100%;
    }

    .button {
        background-color: var(--midground);
        width: 7rem;
        height: 2.5rem;
        border-radius: 1rem;
        text-align: center;
    }
}

body {
    background: var(--background);
    color: var(--foreground);
    font-family: Arial, Helvetica, sans-serif;
}

EOF


# Configs
cat > .prettierrc << 'EOF'
{
    "arrowParens": "always",
    "tabWidth": 4,
    "experimentalTernaries": true,
    "semi": false,
    "trailingComma": "none",
    "bracketSpacing": true,
    "plugins": ["prettier-plugin-tailwindcss"]
}
EOF

cat > eslint.config.mjs << 'EOF'
import { defineConfig, globalIgnores } from "eslint/config"
import nextVitals from "eslint-config-next/core-web-vitals"
import nextTs from "eslint-config-next/typescript"
import prettier from "eslint-config-prettier"

const eslintConfig = defineConfig([
    ...nextVitals,
    ...nextTs,
    prettier,
    // Override default ignores of eslint-config-next.
    globalIgnores([
        // Default ignores of eslint-config-next:
        ".next/**",
        "out/**",
        "build/**",
        "next-env.d.ts"
    ])
])

export default eslintConfig
EOF


# GIT Setup

# git init

# git remote add origin "${Repo_Name}"
# git branch -M main

# git add .
# git commit -m 'initial commit'
# git push -u origin main

echo "copy and paste cd ~/workspace/${Project_Name}-client"


