const opts = glide.o;
opts.hint_size = "14px";

glide.search_engines.add({
    name: "Kagi",
    keyword: "@kagi",
    search_url: "/kagi.com/search?q={searchTerms}",
    favicon_url:
        "https://kagi.com/asset/818992a/kagi_assets/logos/assistant.svg?v=425eb7525c735f3cfa2fafeec743eb734d84280c",
});

const prefs = glide.prefs;

const titleOverrides = {
    "oneupsales.dev": "Local",
    "oneupsales-dev.io": "Staging",
    "oneupsales.io": "Prod",
    "calendar.google.com": "Calendar",
    "github.com": "GitHub",
    "myepaywindow.com": "MyePayWindow",
    "withjuno.com": "Juno",
    "charliehr.com": "CharlieHR",
    "excalidraw.com": "Excalidraw",
    "slite.com": "Slite",
    "xero.com": "Xero",
    "claude.ai": "Claude",
    "oneupsales.atlassian.net": "Jira",
    "wikipedia.org": "Wikipedia",
};

function getOverriddenTitle(url: string, originalTitle: string) {
    try {
        const hostname = new URL(url).hostname;
        for (const [domain, overrideTitle] of Object.entries(titleOverrides)) {
            if (hostname.includes(domain)) {
                return overrideTitle;
            }
        }
    } catch (e) {
        // Invalid URL, return original title
    }
    return originalTitle;
}

glide.autocmds.create("ConfigLoaded", async () => {
    const pinnedTabsContainerEl = document.getElementById(
        "pinned-tabs-container",
    );
    if (!pinnedTabsContainerEl) return;

    const pinnedTabEls =
        pinnedTabsContainerEl.getElementsByClassName("tabbrowser-tab");

    Array.from(pinnedTabEls).forEach((tabEl) => {
        const url = tabEl.getAttribute("url");
        const originalTitle = tabEl.getAttribute("label");
        if (!url || !originalTitle) return;

        const tabTitle = getOverriddenTitle(url, originalTitle);
        console.log("originalTitle", originalTitle);
        console.log("url", url);
        console.log("tabTitle", tabTitle);
        const contentContainerEl = tabEl.querySelector(".tab-content");
        if (!contentContainerEl) return;

        const existingLabel = contentContainerEl.querySelector(
            ".tab-label-container",
        );
        if (existingLabel) {
            existingLabel.remove();
        }

        const titleEl = DOM.create_element("vbox", {
            className: "tab-label-container",
            children: [
                DOM.create_element("label", {
                    className: "tab-label",
                    role: "presentation",
                    textContent: tabTitle,
                }),
            ],
        });

        contentContainerEl.append(titleEl);
    });
});

browser.windows.onFocusChanged.addListener((window) => {
    console.log("onFocusChanged");
    console.log("window", window);
});
browser.windows.onCreated.addListener((window) => {
    console.log("onCreated");
    console.log("window", window);
});
browser.tabs.onActivated.addListener((activeInfo) => {
    console.log("onActivated");
    console.log("activeInfo", activeInfo);
});
browser.tabs.onUpdated.addListener(
    (tabId, changeInfo, tab) => {
        console.log("onUpdated");
        console.log("tab", tab);
        console.log("changeInfo", changeInfo);
        console.log("tabId", tabId);
    },
    { properties: ["pinned"] },
);
browser.tabs.onCreated.addListener((tab) => {
    console.log("onCreated");
    console.log("tab", tab);
});
browser.tabs.onAttached.addListener((tabId, attachInfo) => {
    console.log("onAttached");
    console.log("attachInfo", attachInfo);
    console.log("tabId", tabId);
});

glide.styles.add(`
    #pinned-tabs-container[orient="vertical"] {
      :root:not([sidebar-expand-on-hover]) & {
        @media not -moz-pref("sidebar.visibility", "expand-on-hover") {
          &::part(items-wrapper) {
            display: flex;
            flex-direction: column;
          }

          & .tab-label-container {
            display: flex;
            flex: 1 !important;
            & > label {
                display: inline-block;
                margin-block: 1px 2px;
            }
          }

          & .tabbrowser-tab:not(:hover) > .tab-stack > .tab-background:not([selected], [multiselected]) {
            background-color: transparent;
          }

          & .tab-content {
            background-position-x: calc(var(--tab-inline-padding) + var(--icon-size) + 1px) !important;
          }

          & .tab-icon-image {
            margin-inline-end: var(--tab-icon-end-margin);
          }
        }
      }
    }
`);

// // pick audible tabs (all windows)
// glide.keymaps.set("normal", "<leader>A", async () => {
//   const audible_tabs = await browser.tabs.query({ audible: true })
//   glide.commandline.show({
//     title: "open audio tab",
//     options: audible_tabs.map((tab) => ({
//       label: tab.title ?? tab.url ?? "unreachable?",
//       async execute() {
//         const windowid = tab.windowId
//         if (windowid === undefined) {
//           return
//         }
//         await browser.windows.update(windowid, { focused: true })
//         await browser.tabs.update(tab.id, {
//           active: true,
//         });
//       },
//     })),
//   });
// }, { description: "Search through tabs playing audio" })
//
//                 /**
//  * custom search providers
//  */
// const search_info: Record<string, { url: string, sep: string }> = {
//   'youtube': {
//     url: "https://www.youtube.com/results?search_query=", sep: "+"
//   },
//   'github': {
//     url: 'https://github.com/search?type=repositories&q=', sep: '+'
//   }
// } as const
//
// async function search_site_check(input: string) {
//   const terms = input.split(" ").filter(s => s)
//   const first = terms[0]
//   // check if it's a special search term
//   if (terms.length > 1 && first !== undefined && first in search_info) {
//     let info = search_info[first];
//     let query = info?.url + terms.slice(1).join(info?.sep)
//     return query
//   }
//   return ""
// }
//
// async function about_check(input: string) {
//
//
//   if (input.startsWith("about:")) {
//     return input
//   }
//   return ""
// }
//
// async function get_address(input: string) {
//   let url = null
//
//   if (URL.canParse(input)) {
//     url = URL.parse(input)
//   } else {
//     try {
//       url = new URL("http://" + input) // firefox automatically makes this https
//
//       // avoids single word searches becoming URLs
//       if (url.hostname.split(".").length == 1 && url.hostname !== "localhost") {
//         throw "probably not a hostname";
//       }
//     } catch (err) {
//       return ""
//     }
//   }
//
//   return url?.toString()
//   // so it IS a URL! Just go to it
// }
//
// glide.keymaps.set("normal", "<leader>P", async () => {
//   const tab = await glide.tabs.active()
//   const pin_status = tab.pinned
//   browser.tabs.update(tab.id, {
//     pinned: !pin_status
//   })
// }, { description: "toggle pinned status" })
//
// glide.keymaps.set("normal", "<leader>p", async () => {
//   const pinned_tabs = await glide.tabs.query({ pinned: true })
//
//   glide.commandline.show({
//     title: "open audio tab",
//     options: pinned_tabs.map((tab) => ({
//       label: tab.title ?? tab.url ?? "unreachable?",
//       async execute() {
//         const windowid = tab.windowId
//         if (windowid === undefined) {
//           return
//         }
//         await browser.windows.update(windowid, { focused: true })
//         await browser.tabs.update(tab.id, {
//           active: true,
//         });
//       },
//     })),
//   });
//
// }, { description: "search pinned tabs" })
//
//
// /*
// * pick tabs via a selection of bookmarks and history
// */
// glide.keymaps.set("normal", "<leader>o", async ({ tab_id }) => {
//   let filtered_combined = await get_bookmarks_and_history()
//
//   glide.commandline.show({
//     title: "open",
//     options: filtered_combined.map((entry) => ({
//       label: entry.title,
//       async execute({ input: input }) {
//         // if we find a meatch
//         if (entry.title.toLowerCase().includes(input.toLowerCase())) {
//           swap_to_selected_tab(entry.url ?? "unreachable")
//         } else { // if there isn't a match
//           let res = await get_url_from(input)
//           if (res === "") {
//             await browser.search.search({
//               query: input.split(" ").filter(s => s).join(" "),
//               disposition: "CURRENT_TAB"
//             })
//
//           } else {
//             await browser.tabs.update(tab_id, {
//               active: true,
//               url: res
//             });
//           }
//         }
//       },
//     })),
//   });
// }, { description: "Open the site searcher" });
//
//
// /*
// * pick tabs via a selection of bookmarks and history, new tab
// */
// glide.keymaps.set("normal", "<leader>O", async () => {
//   let filtered_combined = await get_bookmarks_and_history()
//
//   glide.commandline.show({
//     title: "open (new tab)",
//     options: filtered_combined.map((entry) => ({
//       label: entry.title,
//       async execute({ input: input }) {
//         // if we find a meatch
//
//         if (entry.title.toLowerCase().includes(input.toLowerCase())) {
//           swap_to_selected_tab(entry.url ?? "unreachable")
//         } else { // if there isn't a match
//           let res = await get_url_from(input)
//           const tab = await browser.tabs.create({});
//           if (res === "") {
//             const query = input.split(" ").filter(s => s).join(" ")
//             console
//             await browser.search.search({
//               disposition: "NEW_TAB",
//               query: query
//             })
//           } else {
//             await browser.tabs.update(tab.id, {
//               active: true,
//               url: res
//             });
//           }
//         }
//       },
//     })),
//   });
// }, { description: "Open the site searcher (New Tab)" });
//
// async function get_bookmarks_and_history() {
//   //let combined: Array<Browser.Bookmarks.BookmarkTreeNode | Browser.History.HistoryItem> = []
//   let combined = []
//   const bookmarks = await browser.bookmarks.getRecent(20);
//   bookmarks.forEach(bmark => combined.push({ title: bmark.title, url: bmark.url }))
//   combined.push(...bookmarks)
//
//   const history = await browser.history.search({ text: "" })
//   history.forEach(entry => combined.push({ title: entry.title, url: entry.url }))
//
//   // filtering
//   const newtab = (await browser.runtime.getManifest()).chrome_url_overrides?.newtab
//   const startpage = glide.prefs.get("browser.startup.homepage")
//
//   let filtered_combined = combined.filter(e => e.url !== startpage && e.url !== newtab)
//   return filtered_combined
// }
//
// async function swap_to_selected_tab(url: string) {
//   const tab = await glide.tabs.get_first({
//     url: url,
//   });
//   if (tab) {
//     const windowid = tab.windowId;
//     if (windowid === undefined) {
//       return
//     }
//     await browser.windows.update(windowid, {
//       focused: true
//     })
//     await browser.tabs.update(tab.id, {
//       active: true,
//     });
//   } else {
//
//     await browser.tabs.update((await glide.tabs.active()).id, {
//       active: true,
//       url: url,
//     });
//   }
// }
//
// async function get_url_from(input: string) {
//   let special_search = await about_check(input) || await search_site_check(input) || await get_address(input)
//   return special_search ?? ""
// }
//
//
// glide.keymaps.set("normal", "p", async ({ tab_id }) => {
//   const c = navigator.clipboard
//   const url_maybe = await c.readText()
//
//   let address = await get_url_from(url_maybe)
//
//   if (address !== "") {
//
//     browser.tabs.update(tab_id, {
//       url: address
//     })
//   } else {
//     await browser.search.search({
//       query: url_maybe.split(" ").filter(s => s).join(" "),
//       disposition: "CURRENT_TAB"
//     })
//   }
//
//
// }, { description: "paste url from clipboard" });
//
//
// async function copyFlakeGHFormat(tab_id: number, lead: string) { // should work for forgejo, codeberg, gitlab (ideally)
//   const url = (await browser.tabs.get(tab_id)).url?.split("/")
//   if (url !== undefined && url[3] !== undefined && url[4] !== undefined) {
//     // we want split 4 and 5
//     const flake_url = lead.concat(":", url[3], "/", url[4])
//     await navigator.clipboard.writeText(flake_url)
//   }
// }
//
//
// // copy flake urls
// glide.autocmds.create("UrlEnter", {
//   hostname: "github.com"
// }, async ({ tab_id }) => {
//   glide.buf.keymaps.set(
//     "normal",
//     "yF",
//     async () => { await copyFlakeGHFormat(tab_id, "github") }
//   );
// });
//
//
//
//
// // redirects
// async function redir_host(new_host: string, tab_id: number) {
//   const tab = await browser.tabs.get(tab_id);
//   assert(tab.url !== undefined, "not sure how this would be the case? trace code path for improper usage")
//   let old_url = new URL(tab.url);
//   old_url.host = new_host;
//   return old_url.toString()
// }
//
// /**
//  * redirect `old_host` to `new_host` whenever it is visited
//  */
// async function create_redirect(old_host: string, new_host: string) {
//   glide.autocmds.create("UrlEnter", {
//     hostname: old_host
//   }, async ({ tab_id }) => {
//     let new_url = await redir_host(new_host, tab_id)
//     browser.tabs.update(tab_id, { url: new_url, loadReplace: true })
//   });
// }
//
//
// // reddit to old reddit
// create_redirect("www.reddit.com", "old.reddit.com")
// // eventually I will not have to go to this site. Some day.
// create_redirect("x.com", "nitter.net")
