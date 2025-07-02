import handler from '../pages/api/hello'
import { createMocks } from 'node-mocks-http'

describe('/api/hello', () => {
  test('returns John Doe', async () => {
    const { req, res } = createMocks({ method: 'GET' })
    await handler(req as any, res as any)
    expect(res._getStatusCode()).toBe(200)
    expect(res._getJSONData()).toEqual({ name: 'John Doe' })
  })
})
