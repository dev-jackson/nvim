interface Greeting { message: string }
function greet(g: Greeting): string { return g.message }
console.log(greet({ message: "Hello from TypeScript LSP test" }))
