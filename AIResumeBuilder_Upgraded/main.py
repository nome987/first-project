
import gradio as gr
from interface import generate_resume  # Make sure this exists

def main():
    with gr.Blocks(title="AI Resume Builder 🚀") as app:
        gr.Markdown("""# 🧠 AI Resume Builder
Effortlessly create professional resumes using AI. Just enter your details and let the system do the rest!
""")

        with gr.Row():
            with gr.Column():
                name = gr.Textbox(label="🧑‍💼 Full Name")
                email = gr.Textbox(label="📧 Email Address")
                phone = gr.Textbox(label="📱 Contact Number")
                skills = gr.Textbox(label="🛠️ Skills (comma-separated)")
                experience = gr.Textbox(label="💼 Work Experience")
                education = gr.Textbox(label="🎓 Education Background")
                template = gr.Dropdown(choices=["Classic", "Modern", "Creative"], label="📝 Resume Template", value="Classic")

                generate_btn = gr.Button("⚙️ Generate Resume")

            with gr.Column():
                output = gr.Textbox(label="📄 Generated Resume", lines=25, interactive=False)

        generate_btn.click(
            fn=generate_resume,
            inputs=[name, email, phone, skills, experience, education, template],
            outputs=output
        )

    app.launch()

if __name__ == "__main__":
    main()
