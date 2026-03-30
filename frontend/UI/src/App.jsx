import { useState, useRef, useEffect } from "react";
import ReactMarkdown from "react-markdown";
import "./App.css";

function App() {
    const [messages, setMessages] = useState([]);
    const [input, setInput] = useState("");
    const [isStreaming, setIsStreaming] = useState(false);
    const inputRef = useRef(null);
    const messagesEndRef = useRef(null);   // <-- NEW
    const API_URL = "/chat";

    async function sendMessage() {
        if (!input.trim() || isStreaming) return;

        const userMessage = { role: "user", text: input };
        setMessages((prev) => [...prev, userMessage, { role: "assistant", text: "" }]);
        setInput("");
        setIsStreaming(true);

        try {
            const res = await fetch(API_URL, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ input: userMessage.text })
            });

            if (!res.ok) {
                throw new Error(`HTTP ${res.status}`);
            }

            const reader = res.body.getReader();
            const decoder = new TextDecoder();
            let buffer = "";

            while (true) {
                const { done, value } = await reader.read();
                if (done) break;

                buffer += decoder.decode(value, { stream: true });
                const lines = buffer.split("\n");
                buffer = lines.pop(); // hold the last incomplete line

                for (const line of lines) {
                    if (!line.startsWith("data: ")) continue;
                    const payload = line.slice(6).trim();
                    if (payload === "[DONE]") break;

                    try {
                        const { token, error } = JSON.parse(payload);
                        if (error) throw new Error(error);
                        if (token) {
                            setMessages((prev) => {
                                const updated = [...prev];
                                updated[updated.length - 1] = {
                                    role: "assistant",
                                    text: updated[updated.length - 1].text + token
                                };
                                return updated;
                            });
                        }
                    } catch {
                        // malformed chunk — skip
                    }
                }
            }
        } catch {
            setMessages((prev) => {
                const updated = [...prev];
                updated[updated.length - 1] = {
                    role: "assistant",
                    text: "Error contacting Mr. Beefy backend."
                };
                return updated;
            });
        } finally {
            setIsStreaming(false);
        }
    }

    // Auto-resize textarea
    useEffect(() => {
        if (inputRef.current) {
            inputRef.current.style.height = "auto";
            inputRef.current.style.height = inputRef.current.scrollHeight + "px";
        }
    }, [input]);

    // Auto-scroll to bottom on new messages
    useEffect(() => {
        if (messagesEndRef.current) {
            messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
        }
    }, [messages]);

    return (
        <div className="page">
            <div className="shell">
                <header className="hero">
                    <div className="logo-box">
                        <img src="/favicon.png" alt="Beef AI Software" className="logo-img" />
                    </div>
                    <h1 className="hero-title">Mr. Beefy</h1>
                </header>

                <div className="content-card">
                    <h2 className="section-title">What Is Mr. Beefy?</h2>
                    <p className="section-text">
                        Mr. Beefy is a fully serverless AI agent designed as a hands-on demonstration
                        of my engineering philosophy. Every part of this project—from the infrastructure
                        to the automation to the runtime behavior—reflects how I design, build, and
                        operate real-world systems.
                    </p>

                    <p className="section-text">
                        Ask questions about me, Jordan Oberrath, my background, my work experience, my skills,
                        or about the architecture and design of this project. Mr. Beefy is here to provide
                        insights into who I am as an engineer and how I approach building complex systems.
                    </p>

                    <div className="chat-box">
                        <div className="messages">
                            {messages.map((m, i) => (
                                <div
                                    key={i}
                                    className={`message ${m.role === "user" ? "user" : "assistant"}${
                                        isStreaming && i === messages.length - 1 ? " streaming" : ""
                                    }`}
                                >
                                    <ReactMarkdown>{m.text.replace(/([^\n])\n([^\n])/g, '$1\n\n$2')}</ReactMarkdown>
                                </div>
                            ))}

                            {/* Auto-scroll anchor */}
                            <div ref={messagesEndRef} />
                        </div>

                        <div className="input-row">
                            <textarea
                                ref={inputRef}
                                className="chat-input"
                                value={input}
                                placeholder="Ask Mr. Beefy something..."
                                onChange={(e) => setInput(e.target.value)}
                                onKeyDown={(e) => {
                                    if (e.key === "Enter" && !e.shiftKey) {
                                        e.preventDefault();
                                        sendMessage();
                                    }

                                    // Shift+Enter → newline (your original behavior)
                                    if (e.key === "Enter" && e.shiftKey) {
                                        e.preventDefault();
                                        setInput((prev) => prev + "\n");
                                    }
                                }}
                                rows={1}
                                disabled={isStreaming}
                            />
                            <button onClick={sendMessage} disabled={isStreaming}>
                                {isStreaming ? "..." : "Send"}
                            </button>
                        </div>
                        <p className="copyright">© {new Date().getFullYear()} Beef AI Software</p>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default App;
