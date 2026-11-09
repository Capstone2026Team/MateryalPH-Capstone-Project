import { Component, Suspense, lazy, type ComponentType, type LazyExoticComponent, type ReactNode } from 'react'
import { AsyncLoading, RequestErrorState } from './async-state'

type PageLoader = () => Promise<{ default: ComponentType }>
type PageState = { failed: boolean; page: LazyExoticComponent<ComponentType> }

class PageBoundary extends Component<{ retry: () => PageState['page']; initialPage: PageState['page'] }, PageState> {
  override state: PageState = { failed: false, page: this.props.initialPage }

  static getDerivedStateFromError(): Partial<PageState> {
    return { failed: true }
  }

  override render() {
    if (this.state.failed) return <RequestErrorState
      title="Unable to open this page"
      message="Check your connection and try again. If the problem continues, reload the portal."
      onRetry={() => this.setState({ failed: false, page: this.props.retry() })}
    />
    const Page = this.state.page
    return <Page />
  }
}

/** Keep this boundary mounted around the router so transitions retain the current page. */
export function PortalPageLoading({ children }: { children: ReactNode }) {
  return <Suspense fallback={<AsyncLoading label="Opening page…" />}>{children}</Suspense>
}

/** Declare at module scope. Only the selected page downloads; failed imports can be retried. */
export function lazyPortalPage(load: PageLoader): ComponentType {
  let page = lazy(load)
  const retry = () => (page = lazy(load))
  return function LazyPortalPage() {
    return <PageBoundary retry={retry} initialPage={page} />
  }
}
