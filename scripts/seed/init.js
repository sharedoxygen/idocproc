import { PrismaClient } from '@prisma/client'
import { hash } from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
    // Create users
    const users = await Promise.all([
        prisma.user.create({
            data: {
                email: 'john.doe@example.com',
                name: 'John Doe',
                password: await hash('password123', 10)
            }
        }),
        // Add more users...
    ])

    // Create documents
    const documents = await Promise.all([
        prisma.document.create({
            data: {
                title: 'Q4 Financial Report',
                contentType: 'application/pdf',
                filePath: '/documents/financial/q4_report.pdf',
                userId: users[0].id,
                status: 'processed',
                tags: {
                    create: [
                        { name: 'Report' },
                        { name: 'Financial' }
                    ]
                }
            }
        }),
        // Add more documents...
    ])

    console.log('Seed data created successfully!')
}

main()
    .catch((e) => {
        console.error(e)
        process.exit(1)
    })
    .finally(async () => {
        await prisma.$disconnect()
    }) 